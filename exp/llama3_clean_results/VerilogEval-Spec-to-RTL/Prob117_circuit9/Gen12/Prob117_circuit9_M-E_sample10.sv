module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

// Define the states
reg [2:0] state;
reg [2:0] next_state;

// Define the state transitions
always @(posedge clk) begin
    case (state)
        3'b100: begin // State 4
            if (a) begin
                next_state <= 3'b100; // Stay in state 4 if a is high
            end else begin
                next_state <= 3'b101; // Transition to state 5 if a is low
            end
        end
        3'b101: begin // State 5
            if (a) begin
                next_state <= 3'b100; // Reset to state 4 if a is high
            end else begin
                next_state <= 3'b110; // Transition to state 6 if a is low
            end
        end
        3'b110: begin // State 6
            if (a) begin
                next_state <= 3'b100; // Reset to state 4 if a is high
            end else begin
                next_state <= 3'b000; // Transition to state 0 if a is low
            end
        end
        3'b000: begin // State 0
            if (a) begin
                next_state <= 3'b100; // Reset to state 4 if a is high
            end else begin
                next_state <= 3'b001; // Transition to state 1 if a is low
            end
        end
        3'b001: begin // State 1
            if (a) begin
                next_state <= 3'b100; // Reset to state 4 if a is high
            end else begin
                next_state <= 3'b010; // Not a valid state, but added for completeness
            end
        end
        default: begin
            next_state <= 3'b100; // Reset to state 4 if in an invalid state
        end
    endcase

    // Update the state
    state <= next_state;
end

// Define the output
always @(*) begin
    case (state)
        3'b100: q = 4; // State 4 corresponds to output 4
        3'b101: q = 5; // State 5 corresponds to output 5
        3'b110: q = 6; // State 6 corresponds to output 6
        3'b000: q = 0; // State 0 corresponds to output 0
        3'b001: q = 1; // State 1 corresponds to output 1
        default: q = 4; // Default to output 4 if in an invalid state
    endcase
end

// Initialize the state
initial state = 3'b100;

endmodule