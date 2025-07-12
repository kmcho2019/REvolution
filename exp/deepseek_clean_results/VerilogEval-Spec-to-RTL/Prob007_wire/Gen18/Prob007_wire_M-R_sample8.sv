module WireCell (
    input wire in,
    output wire out
);
    assign out = in;
endmodule

module TopModule (
    input wire in,
    output wire out
);
    WireCell wire_inst (
        .in(in),
        .out(out)
    );
endmodule