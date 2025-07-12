module JC_counter (
    input clk, 
    input rst_n, 
    output reg [63:0] Q
);

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset the counter value to 0 when reset signal is low
        Q <= 64'd0;
    end else begin
        // Update the counter value based on the least significant bit
        if (Q[0] == 1'b0) begin
            // Increment the counter by shifting right and appending a 1 at the most significant bit position
            Q <= {1'b1, Q[63:1]};
        end else begin
            // Decrement the counter by shifting right and appending a 0 at the most significant bit position
            Q <= {1'b0, Q[63:1]};
        end
    end
end

endmodule