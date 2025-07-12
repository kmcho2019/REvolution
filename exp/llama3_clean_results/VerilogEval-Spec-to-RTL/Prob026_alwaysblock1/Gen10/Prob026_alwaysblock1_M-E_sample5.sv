module TopModule(
    input  a,
    input  b,
    output out_assign,
    output out_alwaysblock
);

// Assign statement implementation using a multiplexer
assign out_assign = (a == 1) && (b == 1) ? 1 : 0;

// Combinational always block implementation using a multiplexer
reg out_alwaysblock_reg;
always @(*) begin
    if (a == 1 && b == 1) begin
        out_alwaysblock_reg = 1;
    end else begin
        out_alwaysblock_reg = 0;
    end
end
assign out_alwaysblock = out_alwaysblock_reg;

endmodule