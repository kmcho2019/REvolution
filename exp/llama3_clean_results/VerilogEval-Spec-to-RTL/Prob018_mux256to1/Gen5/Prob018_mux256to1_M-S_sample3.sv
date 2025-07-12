module TopModule(
    input [255:0] in,
    input [7:0] sel,
    output out
);
    // Directly select the output based on the input select signal
    assign out = in[sel];
endmodule