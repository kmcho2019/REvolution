module JC_counter(
    input clk,
    input rst_n,
    output reg [63:0] Q
);

reg [63:0] Q_reg; // Current state of the counter
reg [63:0] Q_next; // Next state of the counter

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the counter to 0
        Q_reg <= 64'd0;
        Q_next <= 64'd0;
    end else begin
        // Compute the next state based on the current state
        if (Q_reg[0] == 1'b0) begin
            Q_next <= {1'b1, Q_reg[63:1]};
        end else begin
            Q_next <= {1'b0, Q_reg[63:1]};
        end
        
        // Update the current state
        Q_reg <= Q_next;
    end
end

assign Q = Q_reg; // Output the current state

endmodule