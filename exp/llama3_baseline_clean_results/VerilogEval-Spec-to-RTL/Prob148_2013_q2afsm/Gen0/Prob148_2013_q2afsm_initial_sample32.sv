module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

reg [1:0] current_state;  // Current state of the FSM
reg [1:0] next_state;    // Next state of the FSM

// State table (next state logic)
always @(*) begin
    case (current_state)
        2'b00: // State A
            if (r == 3'b000) begin
                next_state = 2'b00; // Stay in A if no requests
            end else if (r[0]) begin
                next_state = 2'b01; // Priority to device 0
            end else if (r[1]) begin
                next_state = 2'b10; // Then priority to device 1
            end else begin // r[2] must be 1
                next_state = 2'b11; // Lowest priority to device 2
            end
        2'b01: // State B
            if (r[0]) begin
                next_state = 2'b01; // Stay in B if device 0's request is high
            end else begin
                next_state = 2'b00; // Go back to A if device 0's request is low
            end
        2'b10: // State C
            if (r[1]) begin
                next_state = 2'b10; // Stay in C if device 1's request is high
            end else begin
                next_state = 2'b00; // Go back to A if device 1's request is low
            end
        default: // State D
            next_state = 2'b00; // Since D doesn't have a specified next state, default to A
    endcase
end

// State flip-flops (current state)
always @(posedge clk) begin
    if (~resetn) begin
        current_state <= 2'b00; // Reset to state A
    end else begin
        current_state <= next_state;
    end
end

// Output logic
always @(*) begin
    case (current_state)
        2'b00: begin // State A
            g <= 3'b000;
        end
        2'b01: begin // State B
            g <= 3'b100;
        end
        2'b10: begin // State C
            g <= 3'b010;
        end
        default: begin // State D
            g <= 3'b001; // Though not used, for completeness
        end
    endcase
end

endmodule