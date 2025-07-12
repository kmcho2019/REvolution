module up_down_counter(
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

always @ (posedge clk) begin
    if (reset) begin
        // Reset counter to zero
        count <= 16'd0;
    end else begin
        // Increment or decrement counter based on up_down control signal
        if (up_down) begin
            // Increment counter
            count <= count + 1;
        end else begin
            // Decrement counter
            count <= count - 1;
        end
    end
end

endmodule