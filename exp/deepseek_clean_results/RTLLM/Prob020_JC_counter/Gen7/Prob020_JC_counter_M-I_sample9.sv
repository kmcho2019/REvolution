module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

reg clk_en;
wire [63:0] next_Q;

// Clock gating control
always @(*) begin
    if (!rst_n) begin
        clk_en = 1'b1;
    end else begin
        clk_en = ~((&Q) || (~|Q)); // Disable clock when all 1s or all 0s
    end
end

// Next state logic (pipelined shift)
assign next_Q = Q[0] ? {1'b0, Q[63:32], Q[31:1]} : {1'b1, Q[63:32], Q[31:1]};

// Registered stage with clock gating
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
    end else if (clk_en) begin
        Q <= next_Q;
    end
end

endmodule