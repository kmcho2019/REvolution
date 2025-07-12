module TopModule (
    input  wire in1,
    input  wire in2,
    output wire out
);
    wire or_out;

    assign or_out = in1 | in2;
    assign out = ~or_out;

endmodule