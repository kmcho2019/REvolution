module TopModule(
    input [2:0] in,
    output [1:0] out
);

    // Improved arithmetic approach to calculate population count, 
    // considering the output width and input size limitations
    assign out = (in[0] + in[1] + in[2]);

endmodule