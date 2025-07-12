module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

reg [63:0] Q_next;
wire [63:0] Q_shifted = {~Q[0], Q[63:1]};

// Predictive computation of next state
always @(*) begin
    Q_next = Q_shifted;
end

// Dual-edge triggered implementation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q[62:0] <= 63'b0;  // Clear all except MSB
        Q[63] <= 1'b0;     // Clear MSB separately for better fanout
    end
    else begin
        // Update even bits on positive edge
        for (integer i = 0; i < 64; i = i + 2) begin
            Q[i] <= Q_next[i];
        end
    end
end

always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q[61:1] <= 61'b0;  // Clear odd bits
        Q[63] <= 1'b0;     // Clear MSB again for robustness
    end
    else begin
        // Update odd bits on negative edge
        for (integer i = 1; i < 64; i = i + 2) begin
            Q[i] <= Q_next[i];
        end
    end
end

endmodule