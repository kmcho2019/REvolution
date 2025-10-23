module TopModule (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output reg err
);

    // Explicit state definitions
    parameter [2:0] S0 = 3'd0,  // Initial state (0 received)
                   S1 = 3'd1,  // 1
                   S2 = 3'd2,  // 11
                   S3 = 3'd3,  // 111
                   S4 = 3'd4,  // 1111
                   S5 = 3'd5,  // 11111
                   S6 = 3'd6,  // 111111
                   S7 = 3'd7;  // 1111111+ (error state)

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
            err <= (state == S6 && in) || (state == S7);
        end
    end

    // Output assignments
    assign disc = (state == S5) && !in;
    assign flag = (state == S6) && !in;

endmodule