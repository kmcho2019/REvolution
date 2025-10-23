module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

reg [63:0] Q_next;
wire terminal_state;
reg clk_en;

// Terminal state detection
assign terminal_state = (Q == 64'h0) || (&Q);

// Clock gating logic
always @(*) begin
    if (terminal_state)
        clk_en = 1'b0;
    else
        clk_en = 1'b1;
end

// Shift operation split into two 32-bit segments for better timing
always @(*) begin
    if (!rst_n) begin
        Q_next = 64'b0;
    end else if (clk_en) begin
        if (Q[0] == 1'b0) begin
            Q_next = {1'b1, Q[63:32], Q[31:1]};  // Split shift operation
        end else begin
            Q_next = {1'b0, Q[63:32], Q[31:1]};  // Split shift operation
        end
    end else begin
        Q_next = Q;  // Hold value when clock gated
    end
end

// Register update with gated clock
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
    end else if (clk_en) begin
        Q <= Q_next;
    end
end

endmodule