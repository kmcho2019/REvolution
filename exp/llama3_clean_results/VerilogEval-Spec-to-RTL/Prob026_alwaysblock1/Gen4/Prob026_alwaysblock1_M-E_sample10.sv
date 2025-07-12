module TopModule(
    input  a,
    input  b,
    output out_assign,
    output out_alwaysblock
);

assign out_assign = a & b;

reg out_alwaysblock_reg;
always @(*) begin
    out_alwaysblock_reg = a & b;
end

assign out_alwaysblock = out_alwaysblock_reg;

endmodule

module testbench;
reg a, b;
wire out_assign, out_alwaysblock;

TopModule u_TopModule(
   .a(a),
   .b(b),
   .out_assign(out_assign),
   .out_alwaysblock(out_alwaysblock)
);

initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, testbench);
    a = 0; b = 0;
    #10;
    a = 0; b = 1;
    #10;
    a = 1; b = 0;
    #10;
    a = 1; b = 1;
    #10;
    $finish;
end

endmodule