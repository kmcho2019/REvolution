module TopModule(
    input in,
    output out
);

    wire sel = in;
    wire mux_out;

    // 2-to-1 multiplexer implemented combinationally
    assign mux_out = sel ? in : 1'b0;

    assign out = mux_out;

endmodule