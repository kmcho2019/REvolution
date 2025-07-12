module TopModule (
    input  clk,
    input  a,
    input  b,
    output reg state,
    output q
);

// Combinational logic: output q depends on current state and inputs
assign q = (~state & b) | (state & ((a & b) | (~a & ~b)));

// Sequential logic: update state on rising edge of clk with q
always @(posedge clk) begin
    state <= q;
end

endmodule