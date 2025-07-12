module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

reg [63:0] Q_next;
reg direction;  // 0 = counting up (inject 1), 1 = counting down (inject 0)
reg update_en;  // Clock gating control

// Detect extreme states for clock gating
wire all_zeros = (Q == 64'b0);
wire all_ones = (Q == 64'hFFFFFFFFFFFFFFFF);

always @(*) begin
    // Determine next state
    direction = Q[0];
    update_en = !(all_zeros && direction) && !(all_ones && !direction);
    
    if (!update_en) begin
        Q_next = Q;  // Hold current value
    end else begin
        Q_next = direction ? {1'b0, Q[63:1]} : {1'b1, Q[63:1]};
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
    end else begin
        if (update_en) begin
            Q <= Q_next;
        end
    end
end

endmodule