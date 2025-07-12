module TopModule (
    output one
);
    wire out_wire;
    assign out_wire = 1'b1;
    assign one = out_wire;
endmodule