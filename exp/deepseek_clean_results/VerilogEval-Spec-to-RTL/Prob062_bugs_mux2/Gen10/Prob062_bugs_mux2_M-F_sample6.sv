module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output       out
);

    wire [7:0] mux_out;
    assign mux_out = sel ? b : a;
    assign out = mux_out[0]; // Select LSB of the mux result

endmodule