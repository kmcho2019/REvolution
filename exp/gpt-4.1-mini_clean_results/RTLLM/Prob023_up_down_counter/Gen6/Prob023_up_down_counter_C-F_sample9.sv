module up_down_counter (
    input wire clk,          // Clock signal
    input wire reset,        // Synchronous reset, active high
    input wire up_down,      // Counting direction: 1 = up, 0 = down
    output reg [15:0] count  // 16-bit counter output
);

    // Synchronous process triggered on rising edge of clk
    always @(posedge clk) begin
        if (reset) begin
            // Reset counter to zero
            count <= 16'd0;
        end else begin
            // Increment or decrement count based on up_down signal
            if (up_down) begin
                count <= count + 16'd1;
            end else begin
                count <= count - 16'd1;
            end
        end
    end

endmodule