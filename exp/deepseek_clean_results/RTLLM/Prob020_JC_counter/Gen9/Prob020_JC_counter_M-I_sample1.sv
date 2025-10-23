module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

// Pipeline registers
reg [63:0] Q_next;
reg [31:0] upper_half, lower_half;

// Clock gating control
wire update_enable = (Q[0] != Q[63]); // Only update when pattern is changing

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
        Q_next <= 64'b0;
    end
    else if (update_enable) begin
        // Stage 1: Split into two 32-bit operations
        upper_half <= {~Q[0], Q[63:32]};
        lower_half <= Q[31:1];
        
        // Stage 2: Combine results
        Q_next <= {upper_half, lower_half};
        Q <= Q_next;
    end
end

endmodule