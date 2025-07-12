module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

reg [1:0] state, next_state;

// State flip-flops
always @(posedge clk) begin
    if (~resetn) begin
        state <= 2'b00; // Reset to state A
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case(state)
        2'b00: // State A
            if (~r[0] && ~r[1] && ~r[2]) begin
                next_state = 2'b00; // Stay in A if no requests
            end else if (r[0]) begin
                next_state = 2'b01; // Go to B if device 0 requests
            end else if (r[1]) begin
                next_state = 2'b10; // Go to C if device 1 requests
            end else begin
                next_state = 2'b00; // Go to A (device 2 requests, but it's the lowest priority)
            end
        2'b01: // State B
            if (r[0]) begin
                next_state = 2'b01; // Stay in B if device 0 still requests
            end else begin
                next_state = 2'b00; // Go back to A if device 0 doesn't request
            end
        2'b10: // State C
            if (r[1]) begin
                next_state = 2'b10; // Stay in C if device 1 still requests
            end else begin
                next_state = 2'b00; // Go back to A if device 1 doesn't request
            end
        default:
            next_state = 2'b00; // Default to state A
    endcase
end

// Output logic
always @(*) begin
    case(state)
        2'b00: // State A
            g = 3'b000; // No grants
        2'b01: // State B
            g = 3'b001; // Grant to device 0
        2'b10: // State C
            g = 3'b010; // Grant to device 1
        default:
            g = 3'b000; // Default to no grants
    endcase
end

endmodule