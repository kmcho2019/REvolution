module up_down_counter (
    input wire clk,
    input wire reset,
    input wire up_down,
    output reg [15:0] count
);

    // Synchronous process with synchronous reset and up/down counting
    always @(posedge clk) begin
        if (reset) begin
            count <= 16'd0;           // Reset counter to zero
        end else begin
            if (up_down) begin
                count <= count + 16'd1;  // Increment when up_down = 1
            end else begin
                count <= count - 16'd1;  // Decrement when up_down = 0
            end
        end
    end

endmodule