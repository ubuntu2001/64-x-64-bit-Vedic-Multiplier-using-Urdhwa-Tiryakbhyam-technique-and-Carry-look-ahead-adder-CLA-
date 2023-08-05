`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.08.2023 17:47:47
// Design Name: 
// Module Name: vedic_64x64
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



module vedic_64x64(a,b,c);
input [63:0]a;
input [63:0]b;
output [127:0]c;

wire [63:0]q0;	
wire [63:0]q1;
wire [63:0]q2;
wire [63:0]q3;	
wire [127:0]c;
wire [63:0]temp1;
wire [95:0]temp2;
wire [95:0]temp3;
wire [95:0]temp4;
wire [63:0]q4;
wire [95:0]q5;
wire [95:0]q6;
// using 4 16x16 multipliers
vedic_32x32 z1(a[31:0],b[31:0],q0[63:0]);
vedic_32x32 z2(a[63:32],b[31:0],q1[63:0]);
vedic_32x32 z3(a[31:0],b[63:32],q2[63:0]);
vedic_32x32 z4(a[63:32],b[63:32],q3[63:0]);

// stage 1 adders 
assign temp1 ={32'b0,q0[63:32]};
add_64_bit z5(q1[63:0],temp1,q4);
assign temp2 ={32'b0,q2[63:0]};
assign temp3 ={q3[63:0],32'b0};
add_96_bit z6(temp2,temp3,q5);
assign temp4={32'b0,q4[63:0]};

//stage 2 adder
add_96_bit z7(temp4,q5,q6);
// fnal output assignment 
assign c[31:0]=q0[31:0];
assign c[127:32]=q6[95:0];

endmodule

module add_64_bit
  #(parameter WIDTH =64)
  (
   input [WIDTH-1:0] i_add1,
   input [WIDTH-1:0] i_add2,
   output [WIDTH:0]  o_result
   );
     
  wire [WIDTH:0]     w_C;
  wire [WIDTH-1:0]   w_G, w_P, w_SUM;
 
  // Create the Full Adders
  genvar             ii;
  generate
    for (ii=0; ii<WIDTH; ii=ii+1) 
      begin
        full_adder full_adder_inst
            ( 
              .A(i_add1[ii]),
              .B(i_add2[ii]),
              .Cin(w_C[ii]),
              .S(w_SUM[ii]),
              .Cout()
              );
      end
  endgenerate
 
  // Create the Generate (G) Terms:  Gi=Ai*Bi
  // Create the Propagate Terms: Pi=Ai+Bi
  // Create the Carry Terms:
  genvar             jj;
  generate
    for (jj=0; jj<WIDTH; jj=jj+1) 
      begin
        assign w_G[jj]   = i_add1[jj] & i_add2[jj];
        assign w_P[jj]   = i_add1[jj] | i_add2[jj];
        assign w_C[jj+1] = w_G[jj] | (w_P[jj] & w_C[jj]);
      end
  endgenerate
   
  assign w_C[0] = 1'b0; // no carry input on first adder
 
  assign o_result = {w_C[WIDTH], w_SUM};   // Verilog Concatenation
 
endmodule // carry_lookahead_adder

module add_96_bit
  #(parameter WIDTH =96)
  (
   input [WIDTH-1:0] i_add1,
   input [WIDTH-1:0] i_add2,
   output [WIDTH:0]  o_result
   );
     
  wire [WIDTH:0]     w_C;
  wire [WIDTH-1:0]   w_G, w_P, w_SUM;
 
  // Create the Full Adders
  genvar             ii;
  generate
    for (ii=0; ii<WIDTH; ii=ii+1) 
      begin
        full_adder full_adder_inst
            ( 
              .A(i_add1[ii]),
              .B(i_add2[ii]),
              .Cin(w_C[ii]),
              .S(w_SUM[ii]),
              .Cout()
              );
      end
  endgenerate
 
  // Create the Generate (G) Terms:  Gi=Ai*Bi
  // Create the Propagate Terms: Pi=Ai+Bi
  // Create the Carry Terms:
  genvar             jj;
  generate
    for (jj=0; jj<WIDTH; jj=jj+1) 
      begin
        assign w_G[jj]   = i_add1[jj] & i_add2[jj];
        assign w_P[jj]   = i_add1[jj] | i_add2[jj];
        assign w_C[jj+1] = w_G[jj] | (w_P[jj] & w_C[jj]);
      end
  endgenerate
   
  assign w_C[0] = 1'b0; // no carry input on first adder
 
  assign o_result = {w_C[WIDTH], w_SUM};   // Verilog Concatenation
 
endmodule // carry_lookahead_adder


module vedic_32x32(a,b,c);
input [31:0]a;
input [31:0]b;
output [63:0]c;

wire [31:0]q0;	
wire [31:0]q1;
wire [31:0]q2;
wire [31:0]q3;	
wire [63:0]c;
wire [31:0]temp1;
wire [47:0]temp2;
wire [47:0]temp3;
wire [47:0]temp4;
wire [31:0]q4;
wire [47:0]q5;
wire [47:0]q6;
// using 4 16x16 multipliers
vedic_16x16 z1(a[15:0],b[15:0],q0[31:0]);
vedic_16x16 z2(a[31:16],b[15:0],q1[31:0]);
vedic_16x16 z3(a[15:0],b[31:16],q2[31:0]);
vedic_16x16 z4(a[31:16],b[31:16],q3[31:0]);

// stage 1 adders 
assign temp1 ={16'b0,q0[31:16]};
add_32_bit z5(q1[31:0],temp1,q4);
assign temp2 ={16'b0,q2[31:0]};
assign temp3 ={q3[31:0],16'b0};
add_48_bit z6(temp2,temp3,q5);
assign temp4={16'b0,q4[31:0]};

//stage 2 adder
add_48_bit z7(temp4,q5,q6);
// fnal output assignment 
assign c[15:0]=q0[15:0];
assign c[63:16]=q6[47:0];

endmodule

module add_32_bit
  #(parameter WIDTH =32)
  (
   input [WIDTH-1:0] i_add1,
   input [WIDTH-1:0] i_add2,
   output [WIDTH:0]  o_result
   );
     
  wire [WIDTH:0]     w_C;
  wire [WIDTH-1:0]   w_G, w_P, w_SUM;
 
  // Create the Full Adders
  genvar             ii;
  generate
    for (ii=0; ii<WIDTH; ii=ii+1) 
      begin
        full_adder full_adder_inst
            ( 
              .A(i_add1[ii]),
              .B(i_add2[ii]),
              .Cin(w_C[ii]),
              .S(w_SUM[ii]),
              .Cout()
              );
      end
  endgenerate
 
  // Create the Generate (G) Terms:  Gi=Ai*Bi
  // Create the Propagate Terms: Pi=Ai+Bi
  // Create the Carry Terms:
  genvar             jj;
  generate
    for (jj=0; jj<WIDTH; jj=jj+1) 
      begin
        assign w_G[jj]   = i_add1[jj] & i_add2[jj];
        assign w_P[jj]   = i_add1[jj] | i_add2[jj];
        assign w_C[jj+1] = w_G[jj] | (w_P[jj] & w_C[jj]);
      end
  endgenerate
   
  assign w_C[0] = 1'b0; // no carry input on first adder
 
  assign o_result = {w_C[WIDTH], w_SUM};   // Verilog Concatenation
 
endmodule // carry_lookahead_adder

module add_48_bit
  #(parameter WIDTH =48)
  (
   input [WIDTH-1:0] i_add1,
   input [WIDTH-1:0] i_add2,
   output [WIDTH:0]  o_result
   );
     
  wire [WIDTH:0]     w_C;
  wire [WIDTH-1:0]   w_G, w_P, w_SUM;
 
  // Create the Full Adders
  genvar             ii;
  generate
    for (ii=0; ii<WIDTH; ii=ii+1) 
      begin
        full_adder full_adder_inst
            ( 
              .A(i_add1[ii]),
              .B(i_add2[ii]),
              .Cin(w_C[ii]),
              .S(w_SUM[ii]),
              .Cout()
              );
      end
  endgenerate
 
  // Create the Generate (G) Terms:  Gi=Ai*Bi
  // Create the Propagate Terms: Pi=Ai+Bi
  // Create the Carry Terms:
  genvar             jj;
  generate
    for (jj=0; jj<WIDTH; jj=jj+1) 
      begin
        assign w_G[jj]   = i_add1[jj] & i_add2[jj];
        assign w_P[jj]   = i_add1[jj] | i_add2[jj];
        assign w_C[jj+1] = w_G[jj] | (w_P[jj] & w_C[jj]);
      end
  endgenerate
   
  assign w_C[0] = 1'b0; // no carry input on first adder
 
  assign o_result = {w_C[WIDTH], w_SUM};   // Verilog Concatenation
 
endmodule // carry_lookahead_adder


module vedic_16x16(a,b,c
    );
input [15:0]a;
input [15:0]b;
output [31:0]c;

wire [15:0]q0;	
wire [15:0]q1;	
wire [15:0]q2;
wire [15:0]q3;	
wire [31:0]c;
wire [15:0]temp1;
wire [23:0]temp2;
wire [23:0]temp3;
wire [23:0]temp4;
wire [15:0]q4;
wire [23:0]q5;
wire [23:0]q6;
// using 4 8x8 multipliers
vedic_8X8 z1(a[7:0],b[7:0],q0[15:0]);
vedic_8X8 z2(a[15:8],b[7:0],q1[15:0]);
vedic_8X8 z3(a[7:0],b[15:8],q2[15:0]);
vedic_8X8 z4(a[15:8],b[15:8],q3[15:0]);

// stage 1 adders 
assign temp1 ={8'b0,q0[15:8]};
add_16_bit z5(q1[15:0],temp1,q4);
assign temp2 ={8'b0,q2[15:0]};
assign temp3 ={q3[15:0],8'b0};
add_24_bit z6(temp2,temp3,q5);
assign temp4={8'b0,q4[15:0]};

//stage 2 adder
add_24_bit z7(temp4,q5,q6);
// fnal output assignment 
assign c[7:0]=q0[7:0];
assign c[31:8]=q6[23:0];


endmodule
//add_16_bit
module add_16_bit
  #(parameter WIDTH =16)
  (
   input [WIDTH-1:0] i_add1,
   input [WIDTH-1:0] i_add2,
   output [WIDTH:0]  o_result
   );
     
  wire [WIDTH:0]     w_C;
  wire [WIDTH-1:0]   w_G, w_P, w_SUM;
 
  // Create the Full Adders
  genvar             ii;
  generate
    for (ii=0; ii<WIDTH; ii=ii+1) 
      begin
        full_adder full_adder_inst
            ( 
              .A(i_add1[ii]),
              .B(i_add2[ii]),
              .Cin(w_C[ii]),
              .S(w_SUM[ii]),
              .Cout()
              );
      end
  endgenerate
 
  // Create the Generate (G) Terms:  Gi=Ai*Bi
  // Create the Propagate Terms: Pi=Ai+Bi
  // Create the Carry Terms:
  genvar             jj;
  generate
    for (jj=0; jj<WIDTH; jj=jj+1) 
      begin
        assign w_G[jj]   = i_add1[jj] & i_add2[jj];
        assign w_P[jj]   = i_add1[jj] | i_add2[jj];
        assign w_C[jj+1] = w_G[jj] | (w_P[jj] & w_C[jj]);
      end
  endgenerate
   
  assign w_C[0] = 1'b0; // no carry input on first adder
 
  assign o_result = {w_C[WIDTH], w_SUM};   // Verilog Concatenation
 
endmodule // carry_lookahead_adder

//add_24_bit
module add_24_bit
  #(parameter WIDTH =24)
  (
   input [WIDTH-1:0] i_add1,
   input [WIDTH-1:0] i_add2,
   output [WIDTH:0]  o_result
   );
     
  wire [WIDTH:0]     w_C;
  wire [WIDTH-1:0]   w_G, w_P, w_SUM;
 
  // Create the Full Adders
  genvar             ii;
  generate
    for (ii=0; ii<WIDTH; ii=ii+1) 
      begin
        full_adder full_adder_inst
            ( 
              .A(i_add1[ii]),
              .B(i_add2[ii]),
              .Cin(w_C[ii]),
              .S(w_SUM[ii]),
              .Cout()
              );
      end
  endgenerate
 
  // Create the Generate (G) Terms:  Gi=Ai*Bi
  // Create the Propagate Terms: Pi=Ai+Bi
  // Create the Carry Terms:
  genvar             jj;
  generate
    for (jj=0; jj<WIDTH; jj=jj+1) 
      begin
        assign w_G[jj]   = i_add1[jj] & i_add2[jj];
        assign w_P[jj]   = i_add1[jj] | i_add2[jj];
        assign w_C[jj+1] = w_G[jj] | (w_P[jj] & w_C[jj]);
      end
  endgenerate
   
  assign w_C[0] = 1'b0; // no carry input on first adder
 
  assign o_result = {w_C[WIDTH], w_SUM};   // Verilog Concatenation
 
endmodule // carry_lookahead_adder


module vedic_8X8(a,b,result
    );
   
input [7:0]a;
input [7:0]b;
output [15:0]result;

wire [15:0]q0;	
wire [15:0]q1;	
wire [15:0]q2;
wire [15:0]q3;	
wire [15:0]result;
wire [7:0]temp1;
wire [11:0]temp2;
wire [11:0]temp3;
wire [11:0]temp4;
wire [7:0]q4;
wire [11:0]q5;
wire [11:0]q6;
// using 4 4x4 multipliers
vedic_4_x_4 z1(a[3:0],b[3:0],q0[15:0]);
vedic_4_x_4 z2(a[7:4],b[3:0],q1[15:0]);
vedic_4_x_4 z3(a[3:0],b[7:4],q2[15:0]);
vedic_4_x_4 z4(a[7:4],b[7:4],q3[15:0]);

// stage 1 adders 
assign temp1 ={4'b0,q0[7:4]};
add_8_bit z5(q1[7:0],temp1,q4);
assign temp2 ={4'b0,q2[7:0]};
assign temp3 ={q3[7:0],4'b0};
add_12_bit z6(temp2,temp3,q5);
assign temp4={4'b0,q4[7:0]};
// stage 2 adder
add_12_bit z7(temp4,q5,q6);
// fnal output assignment 
assign result[3:0]=q0[3:0];
assign result[15:4]=q6[11:0];



endmodule
//add_8_bit
module add_8_bit
  #(parameter WIDTH =8)
  (
   input [WIDTH-1:0] i_add1,
   input [WIDTH-1:0] i_add2,
   output [WIDTH:0]  o_result
   );
     
  wire [WIDTH:0]     w_C;
  wire [WIDTH-1:0]   w_G, w_P, w_SUM;
 
  // Create the Full Adders
  genvar             ii;
  generate
    for (ii=0; ii<WIDTH; ii=ii+1) 
      begin
        full_adder full_adder_inst
            ( 
              .A(i_add1[ii]),
              .B(i_add2[ii]),
              .Cin(w_C[ii]),
              .S(w_SUM[ii]),
              .Cout()
              );
      end
  endgenerate
 
  // Create the Generate (G) Terms:  Gi=Ai*Bi
  // Create the Propagate Terms: Pi=Ai+Bi
  // Create the Carry Terms:
  genvar             jj;
  generate
    for (jj=0; jj<WIDTH; jj=jj+1) 
      begin
        assign w_G[jj]   = i_add1[jj] & i_add2[jj];
        assign w_P[jj]   = i_add1[jj] | i_add2[jj];
        assign w_C[jj+1] = w_G[jj] | (w_P[jj] & w_C[jj]);
      end
  endgenerate
   
  assign w_C[0] = 1'b0; // no carry input on first adder
 
  assign o_result = {w_C[WIDTH], w_SUM};   // Verilog Concatenation
 
endmodule // carry_lookahead_adder

//add_12_bit
module add_12_bit
  #(parameter WIDTH =12)
  (
   input [WIDTH-1:0] i_add1,
   input [WIDTH-1:0] i_add2,
   output [WIDTH:0]  o_result
   );
     
  wire [WIDTH:0]     w_C;
  wire [WIDTH-1:0]   w_G, w_P, w_SUM;
 
  // Create the Full Adders
  genvar             ii;
  generate
    for (ii=0; ii<WIDTH; ii=ii+1) 
      begin
        full_adder full_adder_inst
            ( 
              .A(i_add1[ii]),
              .B(i_add2[ii]),
              .Cin(w_C[ii]),
              .S(w_SUM[ii]),
              .Cout()
              );
      end
  endgenerate
 
  // Create the Generate (G) Terms:  Gi=Ai*Bi
  // Create the Propagate Terms: Pi=Ai+Bi
  // Create the Carry Terms:
  genvar             jj;
  generate
    for (jj=0; jj<WIDTH; jj=jj+1) 
      begin
        assign w_G[jj]   = i_add1[jj] & i_add2[jj];
        assign w_P[jj]   = i_add1[jj] | i_add2[jj];
        assign w_C[jj+1] = w_G[jj] | (w_P[jj] & w_C[jj]);
      end
  endgenerate
   
  assign w_C[0] = 1'b0; // no carry input on first adder
 
  assign o_result = {w_C[WIDTH], w_SUM};   // Verilog Concatenation
 
endmodule // carry_lookahead_adder

module vedic_4_x_4(
a,b,result
    );
input [3:0]a;
input [3:0]b;
output [7:0]result;

wire [3:0]q0;	
wire [3:0]q1;	
wire [3:0]q2;
wire [3:0]q3;	
wire [7:0]result;
wire [3:0]temp1;
wire [5:0]temp2;
wire [5:0]temp3;
wire [5:0]temp4;
wire [3:0]q4;
wire [5:0]q5;
wire [5:0]q6;
// using 4 2x2 multipliers
vedic_2x2 z1(a[1:0],b[1:0],q0[3:0]);
vedic_2x2 z2(a[3:2],b[1:0],q1[3:0]);
vedic_2x2 z3(a[1:0],b[3:2],q2[3:0]);
vedic_2x2 z4(a[3:2],b[3:2],q3[3:0]);
// stage 1 adders 
assign temp1 ={2'b0,q0[3:2]};
add_4_bit z5(q1[3:0],temp1,q4);
assign temp2 ={2'b0,q2[3:0]};
assign temp3 ={q3[3:0],2'b0};
add_6_bit z6(temp2,temp3,q5);
assign temp4={2'b0,q4[3:0]};
// stage 2 adder 
add_6_bit z7(temp4,q5,q6);
// fnal output assignment 
assign result[1:0]=q0[1:0];
assign result[7:2]=q6[5:0];



endmodule

//add_4_bit
module add_4_bit
  #(parameter WIDTH =4)
  (
   input [WIDTH-1:0] i_add1,
   input [WIDTH-1:0] i_add2,
   output [WIDTH:0]  o_result
   );
     
  wire [WIDTH:0]     w_C;
  wire [WIDTH-1:0]   w_G, w_P, w_SUM;
 
  // Create the Full Adders
  genvar             ii;
  generate
    for (ii=0; ii<WIDTH; ii=ii+1) 
      begin
        full_adder full_adder_inst
            ( 
              .A(i_add1[ii]),
              .B(i_add2[ii]),
              .Cin(w_C[ii]),
              .S(w_SUM[ii]),
              .Cout()
              );
      end
  endgenerate
 
  // Create the Generate (G) Terms:  Gi=Ai*Bi
  // Create the Propagate Terms: Pi=Ai+Bi
  // Create the Carry Terms:
  genvar             jj;
  generate
    for (jj=0; jj<WIDTH; jj=jj+1) 
      begin
        assign w_G[jj]   = i_add1[jj] & i_add2[jj];
        assign w_P[jj]   = i_add1[jj] | i_add2[jj];
        assign w_C[jj+1] = w_G[jj] | (w_P[jj] & w_C[jj]);
      end
  endgenerate
   
  assign w_C[0] = 1'b0; // no carry input on first adder
 
  assign o_result = {w_C[WIDTH], w_SUM};   // Verilog Concatenation
 
endmodule // carry_lookahead_adder


//add_6_bit
module add_6_bit
  #(parameter WIDTH =6)
  (
   input [WIDTH-1:0] i_add1,
   input [WIDTH-1:0] i_add2,
   output [WIDTH:0]  o_result
   );
     
  wire [WIDTH:0]     w_C;
  wire [WIDTH-1:0]   w_G, w_P, w_SUM;
 
  // Create the Full Adders
  genvar             ii;
  generate
    for (ii=0; ii<WIDTH; ii=ii+1) 
      begin
        full_adder full_adder_inst
            ( 
              .A(i_add1[ii]),
              .B(i_add2[ii]),
              .Cin(w_C[ii]),
              .S(w_SUM[ii]),
              .Cout()
              );
      end
  endgenerate
 
  // Create the Generate (G) Terms:  Gi=Ai*Bi
  // Create the Propagate Terms: Pi=Ai+Bi
  // Create the Carry Terms:
  genvar             jj;
  generate
    for (jj=0; jj<WIDTH; jj=jj+1) 
      begin
        assign w_G[jj]   = i_add1[jj] & i_add2[jj];
        assign w_P[jj]   = i_add1[jj] | i_add2[jj];
        assign w_C[jj+1] = w_G[jj] | (w_P[jj] & w_C[jj]);
      end
  endgenerate
   
  assign w_C[0] = 1'b0; // no carry input on first adder
 
  assign o_result = {w_C[WIDTH], w_SUM};   // Verilog Concatenation
 
endmodule // carry_lookahead_adder

// Verilog code for full adder 
module full_adder(S,Cout,A,B,Cin);
output S,Cout;
input A,B,Cin;
assign S=(A ^ B) ^ Cin;
assign Cout = ((A ^ B) & Cin) | (A & B);
endmodule 


module vedic_2x2(
a,
b,
result
    );
input [1:0]a;
input [1:0]b;
output [3:0]result;
wire [3:0]result;
wire [3:0]temp;
//stage 1
// four multiplication operation of bits accourding to vedic logic done using and gates 
assign result[0]=a[0]&b[0]; 
assign temp[0]=a[1]&b[0];
assign temp[1]=a[0]&b[1];
assign temp[2]=a[1]&b[1];
//stage two 
// using two half adders 
ha z1(temp[0],temp[1],result[1],temp[3]);
ha z2(temp[2],temp[3],result[2],result[3]);
endmodule


module ha (
    input a,b,
    output sum,carry
);

assign sum = a ^ b;
assign carry = a & b;

endmodule

