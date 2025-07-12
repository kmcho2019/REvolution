module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    // State definitions (binary encoded)
    parameter [2:0] S0 = 3'b000,
                   S1 = 3'b001,
                   S2 = 3'b010,
                   S3 = 3'b011,
                   S4 = 3'b100;

    reg [2:0] state, next_state;

    // Next state logic (case statement for better timing)
    always @(*) begin
        case (state)
            S0: next_state = x ? S1 : S0;
            S1: next_state = x ? S4 : S1;
            S2: next_state = x ? S1 : S2;
            S3: next_state = x ? S2 : S1;
            S4: next_state = x ? S4 : S3;
            default: next_state = S0;
        endcase
    end

    // State transition with synchronous reset
    always @(posedge clk) begin
        state <= reset ? S0 : next_state;
    end

    // Output logic optimized (direct from state bits)
    assign z = state[2] | (state[1] & state[0]);

endmodule