module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  out
);

    // Use SystemVerilog enum for states
    typedef enum logic [1:0] {
        A = 2'd0,
        B = 2'd1,
        C = 2'd2,
        D = 2'd3
    } state_t;

    state_t state, next_state;

    // Sequential logic: update state and output synchronously at posedge clk
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            out   <= 1'b0;
        end else begin
            // Next state logic
            case (state)
                A: next_state <= (in == 1'b0) ? A : B;
                B: next_state <= (in == 1'b0) ? C : B;
                C: next_state <= (in == 1'b0) ? A : D;
                D: next_state <= (in == 1'b0) ? C : B;
                default: next_state <= A;
            endcase

            state <= next_state;

            // Moore output logic: output depends on next state
            // but because it's Moore, output depends on current state.
            // So keep output based on current state, updated synchronously
            case (state)
                D: out <= 1'b1;
                default: out <= 1'b0;
            endcase
        end
    end

endmodule