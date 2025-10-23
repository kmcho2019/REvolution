// Module for AND gate implementation using a multiplexer
module TopModule(
    input  a,
    input  b,
    output out_assign,
    output out_alwaysblock
);

// Using a 2:1 MUX to implement an AND gate
assign out_assign = (a & b) ? 1'b1 : 1'b0;

reg out_alwaysblock_reg;
always @(*) begin
    out_alwaysblock_reg = (a & b) ? 1'b1 : 1'b0;
    out_alwaysblock = out_alwaysblock_reg;
end

endmodule