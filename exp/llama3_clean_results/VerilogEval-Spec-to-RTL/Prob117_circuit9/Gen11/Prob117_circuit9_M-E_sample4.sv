module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

reg [1:0] state; // FSM state

// Initialize the output and state
initial begin
    q = 4;
    state = 2'b00; // Initial state
end

// Define the FSM
always @(posedge clk) begin
    case (state)
        2'b00: // Reset state
            if (a) begin
                state <= 2'b00; // Stay in reset state if 'a' is high
            end else begin
                state <= 2'b01; // Move to increment state if 'a' is low
            end
        2'b01: // Increment state
            if (a) begin
                state <= 2'b00; // Move to reset state if 'a' is high
            end else begin
                state <= 2'b01; // Stay in increment state if 'a' is low
            end
        default: // Invalid state
            state <= 2'b00; // Move to reset state
    endcase
end

// Define the counter
always @(posedge clk) begin
    case (state)
        2'b00: // Reset state
            q <= 4; // Reset counter to 4
        2'b01: // Increment state
            if (q < 6) begin
                q <= q + 1; // Increment counter if less than 6
            end else begin
                q <= 0; // Wrap around to 0 if equal to 6
            end
        default: // Invalid state
            q <= 4; // Reset counter to 4
    endcase
end

endmodule