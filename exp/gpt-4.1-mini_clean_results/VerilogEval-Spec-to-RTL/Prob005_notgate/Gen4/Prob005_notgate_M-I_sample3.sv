module TopModule (
    input  in,
    output out
);

    wire out_wire;
    assign out_wire = ~in;
    assign out = out_wire;

endmodule