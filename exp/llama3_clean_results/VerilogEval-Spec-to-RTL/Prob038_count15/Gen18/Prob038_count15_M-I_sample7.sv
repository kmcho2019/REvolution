module TopModule(
    input clk,
    input reset,
    output reg [3:0] q,
    input enable // Added enable signal for clock gating
);

reg [3:0] next_q;

// Calculate the next state without the need for an always block
always @(*) begin
    if (reset) begin
        next_q = 4'd0;
    end else if (enable) begin
        next_q = q + 1'd1;
    end else begin
        next_q = q;
    end
end

// Use a clock enable to gate the clock when not needed
always @(posedge clk) begin
    if (enable) begin
        q <= next_q;
    end
end

endmodule