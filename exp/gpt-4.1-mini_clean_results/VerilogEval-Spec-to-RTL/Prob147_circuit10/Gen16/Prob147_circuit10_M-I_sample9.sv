module TopModule (
    input  clk,
    input  a,
    input  b,
    output reg state,
    output q
);

// Next state and output logic: q depends on current state and inputs
assign q = (~state & b) | (state & ~(a ^ b));

always @(posedge clk) begin
    state <= q;
end

endmodule