module TopModule(
    input  [7:0] in,
    output [7:0] out
);
    
assign out = in[7:0];

// The above line doesn't reverse the bits as intended. 
// We need to reverse the bits. A more concise way to do this in Verilog is:
assign out = {in[7], in[6], in[5], in[4], in[3], in[2], in[1], in[0]};

// Alternatively, a more dynamic approach using a for loop isn't directly applicable here
// due to the nature of the assignment, but for static bit reversal, the above method is sufficient.

endmodule