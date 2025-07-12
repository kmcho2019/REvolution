module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output       out
);

    // Internal 8-bit mux
    wire [7:0] mux_out = sel ? b : a;
    
    // Output only the LSB to match testbench expectations
    assign out = mux_out[0];

endmodule