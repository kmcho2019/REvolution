module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // State encoding
    localparam [2:0]
        S0 = 3'd0,
        S1 = 3'd1,
        S2 = 3'd2,
        S3 = 3'd3,
        S4 = 3'd4,
        S5 = 3'd5,
        S6 = 3'd6,
        S7 = 3'd7; // error state (7 or more 1s)

    reg [2:0] state, next_state;
    reg prev_in;

    // Next state logic
    always @(*) begin
        case (state)
            S0: next_state = (in) ? S1 : S0;
            S1: next_state = (in) ? S2 : S0;
            S2: next_state = (in) ? S3 : S0;
            S3: next_state = (in) ? S4 : S0;
            S4: next_state = (in) ? S5 : S0;
            S5: next_state = (in) ? S6 : S0;
            S6: next_state = (in) ? S7 : S0;
            S7: next_state = (in) ? S7 : S0;
            default: next_state = S0;
        endcase
    end

    // State and previous input update
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            prev_in <= 1'b0;
            disc <= 1'b0;
            flag <= 1'b0;
            err <= 1'b0;
        end else begin
            state <= next_state;

            // Outputs generation on the cycle after condition is detected
            // Conditions detected:
            // disc: previous state = S5 and previous input = 1 and current input = 0
            // flag: previous state = S6 and previous input = 1 and current input = 0
            // err: current state = S7

            disc <= (state == S5) && (prev_in == 1'b1) && (in == 1'b0);
            flag <= (state == S6) && (prev_in == 1'b1) && (in == 1'b0);
            err <= (next_state == S7);

            prev_in <= in;
        end
    end

endmodule