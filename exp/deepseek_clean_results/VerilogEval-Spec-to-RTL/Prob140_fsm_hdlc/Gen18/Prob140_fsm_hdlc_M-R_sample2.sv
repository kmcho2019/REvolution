module TopModule (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output reg err
);

    // Explicit state definitions
    parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4, S5 = 5, S6 = 6, S7 = 7;
    reg [2:0] state, next_state;

    // State transition logic
    always @(*) begin
        case (state)
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S2 : S0;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S4 : S0;
            S4: next_state = in ? S5 : S0;
            S5: next_state = in ? S6 : S0;
            S6: next_state = in ? S7 : S0;
            S7: next_state = in ? S7 : S0;
            default: next_state = S0;
        endcase
    end

    // State register
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            err <= 0;
        end else begin
            state <= next_state;
            err <= (state >= S6) && in;
        end
    end

    // Output assignments
    assign disc = (state == S5) && !in;
    assign flag = (state == S6) && !in;

endmodule