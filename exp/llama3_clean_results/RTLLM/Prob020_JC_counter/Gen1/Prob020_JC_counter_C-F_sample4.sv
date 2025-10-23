module JC_counter(
    input clk, 
    input rst_n, 
    output reg [63:0] Q
);

// Always block to capture rising edge of clk and falling edge of rst_n
always @ (posedge clk or negedge rst_n) begin
    // Reset condition: set Q to 0 when rst_n is low
    if (~rst_n) begin
        Q <= 64'd0;
    end else begin
        // Normal operation
        // Check the least significant bit (Q[0]) of the current count value
        if (Q[0] == 1'b0) begin
            // Increment: shift Q[63:1] to the right and append 1 at MSB
            Q <= {1'b1, Q[63:1]};
        end else begin
            // Decrement: shift Q[63:1] to the right and append 0 at MSB
            Q <= {1'b0, Q[63:1]};
        end
    end
end

endmodule