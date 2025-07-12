module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

reg [63:0] Q_next;
wire [31:0] upper_stage, lower_stage;
wire counter_active;
reg clk_en;

// Clock gating logic
assign counter_active = !((&Q) || (|Q == 0)); // Not all 1s or all 0s

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_en <= 1'b1;
    end else begin
        clk_en <= counter_active;
    end
end

// Pipelined shift operation
assign upper_stage = {~Q[0], Q[63:33]}; // First 32-bit shift stage
assign lower_stage = {upper_stage[31], Q[32:1]}; // Second 32-bit shift stage

always @(*) begin
    Q_next = {upper_stage[31:0], lower_stage[31:0]};
end

// Clock-gated register update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
    end else if (clk_en) begin
        Q <= Q_next;
    end
end

endmodule