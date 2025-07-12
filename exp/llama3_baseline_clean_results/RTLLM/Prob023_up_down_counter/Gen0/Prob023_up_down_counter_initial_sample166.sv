module up_down_counter (
    input clk, // Clock signal
    input reset, // Reset signal
    input up_down, // Control signal to determine counting direction
    output [15:0] count // 16-bit output representing the current counter value
);

reg [15:0] count_reg; // Internal register to hold the counter value

// Synchronous process triggered by the rising edge of the clock signal
always @ (posedge clk) begin
    if (reset) begin // Reset condition
        count_reg <= 16'd0; // Reset the counter to zero
    end else begin
        if (up_down) begin // Increment condition
            count_reg <= count_reg + 1; // Increment the counter
        end else begin // Decrement condition
            count_reg <= count_reg - 1; // Decrement the counter
        end
    end
end

// Continuous assignment to output the current counter value
assign count = count_reg;

endmodule