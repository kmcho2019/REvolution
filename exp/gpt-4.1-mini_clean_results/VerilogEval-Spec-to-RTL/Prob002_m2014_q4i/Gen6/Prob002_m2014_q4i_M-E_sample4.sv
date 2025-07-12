module ZeroBuffer(
    input wire in,
    output wire out
);
    assign out = in;
endmodule

module TopModule(
    output wire out
);
    wire zero_signal;
    assign zero_signal = 1'b0;

    ZeroBuffer buf_inst (
        .in(zero_signal),
        .out(out)
    );
endmodule