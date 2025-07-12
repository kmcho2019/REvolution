module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  out
);

    // One-hot state registers
    reg state_B, state_A;
    reg next_state_B, next_state_A;

    // Next state combinational logic
    always @(*) begin
        case ({state_B, state_A})
            2'b10: // State B
                if (in == 1'b0) begin
                    next_state_B = 1'b0;
                    next_state_A = 1'b1;
                end else begin
                    next_state_B = 1'b1;
                    next_state_A = 1'b0;
                end
            2'b01: // State A
                if (in == 1'b0) begin
                    next_state_B = 1'b1;
                    next_state_A = 1'b0;
                end else begin
                    next_state_B = 1'b0;
                    next_state_A = 1'b1;
                end
            default: // Invalid state, reset to B
                begin
                    next_state_B = 1'b1;
                    next_state_A = 1'b0;
                end
        endcase
    end

    // State update with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state_B <= 1'b1;
            state_A <= 1'b0;
        end else begin
            state_B <= next_state_B;
            state_A <= next_state_A;
        end
    end

    // Output logic: out=1 when in B, else 0
    always @(*) begin
        out = state_B;
    end

endmodule