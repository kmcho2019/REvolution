module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

    // One-hot state bits
    reg state_A, state_B;

    // Next state signals
    reg next_state_A, next_state_B;

    // Next state combinational logic
    always @(*) begin
        // Default assignments
        next_state_A = state_A;
        next_state_B = state_B;

        case ({state_A, state_B})
            2'b10: begin // State B
                // In state B, stay in B regardless of x
                next_state_A = 1'b0;
                next_state_B = 1'b1;
            end
            2'b01: begin // State A
                if (x == 1'b0) begin
                    next_state_A = 1'b1; // stay in A
                    next_state_B = 1'b0;
                end else begin
                    next_state_A = 1'b0;
                    next_state_B = 1'b1; // go to B
                end
            end
            default: begin
                // Defensive: reset to A state if invalid encoding
                next_state_A = 1'b1;
                next_state_B = 1'b0;
            end
        endcase
    end

    // State flip-flops with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1;  // Reset to state A (one-hot)
            state_B <= 1'b0;
        end else begin
            state_A <= next_state_A;
            state_B <= next_state_B;
        end
    end

    // Output logic (Mealy): z depends on current state and input x
    // State A (01): z = x
    // State B (10): z = ~x
    assign z = (state_A) ? x : (~x);

endmodule