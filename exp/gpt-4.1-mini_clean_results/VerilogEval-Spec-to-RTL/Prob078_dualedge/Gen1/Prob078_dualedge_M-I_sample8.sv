module TopModule (
    input clk,
    input d,
    output reg q
);

reg q_pos;
reg q_neg;
reg q_mux;

// Flip-flop triggered on rising edge of clk
always @(posedge clk) begin
    q_pos <= d;
end

// Flip-flop triggered on falling edge of clk
always @(negedge clk) begin
    q_neg <= d;
end

// Mux between q_pos and q_neg depending on clk level
always @(*) begin
    if (clk)
        q_mux = q_pos;
    else
        q_mux = q_neg;
end

// Registered output to break combinational path and improve timing/power
always @(posedge clk) begin
    q <= q_mux;
end

endmodule