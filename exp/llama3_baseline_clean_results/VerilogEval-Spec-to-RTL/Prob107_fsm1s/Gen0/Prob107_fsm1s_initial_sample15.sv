module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

// Define the states
localparam B = 1'b1; // State B
localparam A = 1'b0; // State A

reg current_state; // To store the current state
reg next_state;    // To store the next state

always @(posedge clk) begin
    if(reset) begin // If reset is high
        current_state <= B; // Reset to state B
    end else begin
        current_state <= next_state; // Update current state
    end
end

always @(*) begin
    case(current_state)
        B: begin
            if(in == 1'b0) begin
                next_state = A; // Transition to A if in is 0
            end else begin
                next_state = B; // Stay in B if in is 1
            end
        end
        A: begin
            if(in == 1'b0) begin
                next_state = B; // Transition to B if in is 0
            end else begin
                next_state = A; // Stay in A if in is 1
            end
        end
        default: next_state = B; // Default to state B
    endcase
end

always @(*) begin
    case(current_state)
        B: out = 1'b1; // Output is 1 when in state B
        A: out = 1'b0; // Output is 0 when in state A
        default: out = 1'b1; // Default output to 1
    endcase
end

endmodule