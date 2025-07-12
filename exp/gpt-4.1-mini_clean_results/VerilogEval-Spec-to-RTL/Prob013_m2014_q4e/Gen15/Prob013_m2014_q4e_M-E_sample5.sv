module TopModule (
    input wire in1,
    input wire in2,
    output wire out
);
    wire or_out;

    // 2-input OR gate
    assign or_out = in1 | in2;

    // NOT gate to invert OR output, completing NOR
    assign out = ~or_out;

endmodule