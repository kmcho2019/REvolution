module TopModule(output out);
    parameter ZERO = 1'b0;
    wire out_wire;
    assign out_wire = ZERO;
    assign out = out_wire;
endmodule