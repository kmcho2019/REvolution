module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

// Define the states
parameter STATE_B = 1'b0;
parameter STATE_A = 1'b1;

// Current state register
reg current_state;

// Initialize output based on state
always_comb begin
    case (current_state)
        STATE_B: out = 1'b1;
        STATE_A: out = 1'b0;
    endcase
end

// Update state based on clock and reset
always_ff @(posedge clk) begin
    if (reset) begin
        // Synchronous reset to state B
        current_state <= STATE_B;
    end else begin
        // Transition based on current state and input
        case (current_state)
            STATE_B: begin
                if (in == 1'b0) begin
                    current_state <= STATE_A;
                end else begin
                    current_state <= STATE_B;
                end
            end
            STATE_A: begin
                if (in == 1'b0) begin
                    current_state <= STATE_B;
                end else begin
                    current_state <= STATE_A;
                end
            end
        endcase
    end
end

endmodule