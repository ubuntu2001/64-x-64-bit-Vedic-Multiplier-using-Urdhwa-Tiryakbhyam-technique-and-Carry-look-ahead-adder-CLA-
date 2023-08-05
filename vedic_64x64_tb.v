`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.08.2023 17:49:03
// Design Name: 
// Module Name: vedic_64x64_tb
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


module vedic_64x64_tb;
  reg [63:0] a;
  reg [63:0] b;
  wire [127:0] c;

  vedic_64x64 dut (
    .a(a),
    .b(b),
    .c(c)
  );

  initial begin
    $monitor("a = %b, b = %b, c = %b", a, b, c);

    // Test Case 1
   
    a = 64'b0000000000110011000000000011001100000000001100110000000000110011;
    b = 64'b0000000001010101000000000101010100000000010101010000000001010101;

    // Test Case 2
    #10;
    a = 64'b0000110011001100000011001100110000001100110011000000110011001100;
    b = 64'b0010101010101010001010101010101000101010101010100010101010101010;

    // Test Case 3
    #10;
    a = 64'b0001000011110000000100001111000000010000111100000001000011110000;
    b = 64'b0000111100001111000011110000111100001111000011110000111100001111;

    // Add more test cases here if needed

    #10;
    $finish;
  end
endmodule

