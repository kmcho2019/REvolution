module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire in,
    output wire out
);

    // State encoding: one-hot
    // state_A: 1 when in state A, 0 otherwise
    // state_B: 1 when in state B, 0 otherwise
    reg state_A, state_B;
    reg next_state_A, next_state_B;

    // Next state combinational logic based on state and input
    always @(*) begin
        // Default no change
        next_state_A = state_A;
        next_state_B = state_B;

        case ({state_A, state_B})
            2'b10: begin // Current state A
                if (in == 1'b1) begin
                    next_state_A = 1'b1;
                    next_state_B = 1'b0;
                end else begin
                    next_state_A = 1'b0;
                    next_state_B = 1'b1;
                end
            end
            2'b01: begin // Current state B
                if (in == 1'b0) begin
                    next_state_A = 1'b1;
                    next_state_B = 1'b0;
                end else begin
                    next_state_A = 1'b0;
                    next_state_B = 1'b1;
                end
            end
            default: begin // Invalid state, default to B
                next_state_A = 1'b0;
                next_state_B = 1'b1;
            end
        endcase
    end

    // Sequential logic with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b0;
            state_B <= 1'b1; // Reset to B
        end else begin
            state_A <= next_state_A;
            state_B <= next_state_B;
        end
    end

    // Moore output: output is 1 in state B, 0 in state A
    assign out = state_B;

endmodule