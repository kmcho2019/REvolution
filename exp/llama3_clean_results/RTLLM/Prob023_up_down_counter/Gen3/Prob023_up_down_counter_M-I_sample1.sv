module up_down_counter(
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

reg clk_gated;

// Clock gating
always @ (posedge clk) begin
    if (reset) begin
        // Reset counter to zero
        count <= 16'd0;
        clk_gated <= 1'b0;
    end else begin
        // Increment or decrement counter based on up_down control signal
        if (up_down) begin
            // Increment counter
            count <= count + 1;
        end else begin
            // Decrement counter
            count <= count - 1;
        end
        // Enable clock gating
        if (count == 16'd65535 && up_down) begin
            clk_gated <= 1'b0;
        end else if (count == 16'd0 && ~up_down) begin
            clk_gated <= 1'b0;
        end else begin
            clk_gated <= 1'b1;
        end
    end
end

// Use asynchronous reset
always @ (*) begin
    if (~reset) begin
        count <= 16'd0;
    end
end

endmodule