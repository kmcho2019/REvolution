module TopModule (
    output out
);
    wire out_wire;
    parameter ZERO = 1'b0;
    assign out_wire = ZERO;
    assign out = out_wire;
endmodule