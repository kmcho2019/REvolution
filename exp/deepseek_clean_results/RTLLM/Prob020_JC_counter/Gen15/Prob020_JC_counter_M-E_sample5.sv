module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

reg direction;  // 0 for right shift (increment), 1 for left shift (decrement)

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
        direction <= 0;
    end else begin
        // Check for pattern extremes to toggle direction
        if (Q == 64'hFFFFFFFFFFFFFFFF) begin
            direction <= 1;
        end else if (Q == 64'h0) begin
            direction <= 0;
        end

        // Perform shift based on current direction
        if (direction == 0) begin
            Q <= {1'b1, Q[63:1]};  // Right shift with 1 inserted at MSB
        end else begin
            Q <= {Q[62:0], 1'b0};  // Left shift with 0 inserted at LSB
        end
    end
end

endmodule