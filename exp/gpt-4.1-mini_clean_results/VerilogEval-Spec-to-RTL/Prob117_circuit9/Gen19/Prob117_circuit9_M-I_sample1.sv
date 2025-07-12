module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

wire [2:0] next_q_arith;

// Calculate next state as (q + 1) mod 7
assign next_q_arith = (q == 3'd6) ? 3'd0 : q + 3'd1;

wire [2:0] next_q = a ? 3'd4 : next_q_arith;

always @(posedge clk) begin
    // Update q only if next_q differs to reduce unnecessary toggling
    if (q != next_q)
        q <= next_q;
end

endmodule