module JC_counter(
    input clk, 
    input rst_n, 
    output reg [63:0] Q
);

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset condition: set Q to 0
        Q <= 64'd0;
    end else begin
        // Normal operation
        if (Q[0] == 1'b0) begin
            // Increment: shift Q[63:1] to the right and append 1
            Q <= {1'b1, Q[63:1]};
        end else begin
            // Decrement: shift Q[63:1] to the right and append 0
            Q <= {1'b0, Q[63:1]};
        end
    end
end

endmodule