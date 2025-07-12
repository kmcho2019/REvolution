module up_down_counter(
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

    always @ (posedge clk) begin
        if (reset) begin
            // Reset the counter to zero when reset is active
            count <= 16'd0;
        end else begin
            // Increment or decrement the counter based on the up_down signal
            if (up_down) begin
                // Increment the counter
                count <= count + 1;
            end else begin
                // Decrement the counter
                count <= count - 1;
            end
        end
    end

endmodule