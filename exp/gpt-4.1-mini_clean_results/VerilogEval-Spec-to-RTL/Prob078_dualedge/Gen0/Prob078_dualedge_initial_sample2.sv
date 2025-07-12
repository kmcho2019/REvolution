module TopModule (
    input clk,
    input d,
    output reg q
);

reg q_pos;
reg q_neg;

// Flip-flop triggered on rising edge of clk
always @(posedge clk) begin
    q_pos <= d;
end

// Flip-flop triggered on falling edge of clk
always @(negedge clk) begin
    q_neg <= d;
end

// Multiplex between q_pos and q_neg depending on clk level
always @(*) begin
    if (clk)
        q = q_pos;
    else
        q = q_neg;
end

endmodule