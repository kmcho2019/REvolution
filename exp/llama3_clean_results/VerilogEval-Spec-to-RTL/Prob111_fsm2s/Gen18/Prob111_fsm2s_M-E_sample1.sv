module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg [0:0] current_state; // Current state (OFF or ON)
reg [0:0] next_state; // Next state

// LUT for state transitions and output generation
always_comb begin
    case (current_state)
        1'b0: begin // OFF state
            if (j) begin
                next_state = 1'b1; // Transition to ON state
                out = 1'b0; // Output remains 0
            end else begin
                next_state = 1'b0; // Remain in OFF state
                out = 1'b0; // Output remains 0
            end
        end
        1'b1: begin // ON state
            if (k) begin
                next_state = 1'b0; // Transition to OFF state
                out = 1'b1; // Output remains 1
            end else begin
                next_state = 1'b1; // Remain in ON state
                out = 1'b1; // Output remains 1
            end
        end
        default: begin
            next_state = 1'b0; // Default to OFF state
            out = 1'b0; // Default output 0
        end
    endcase
end

// State register with synchronous reset
always_ff @(posedge clk) begin
    if (reset) begin
        current_state <= 1'b0; // Reset to OFF state
    end else begin
        current_state <= next_state; // Update current state
    end
end

endmodule