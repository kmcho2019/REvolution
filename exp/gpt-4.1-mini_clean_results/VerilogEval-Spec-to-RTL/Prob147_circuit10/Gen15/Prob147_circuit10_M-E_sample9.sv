module TopModule (
    input  clk,
    input  a,
    input  b,
    output reg state,
    output q
);

wire q_next;

// Combinational logic based on previous state and inputs
assign q_next = (~state & b) | (state & ((a & b) | (~a & ~b)));

assign q = q_next;

always @(posedge clk) begin
    state <= q_next;
end

endmodule