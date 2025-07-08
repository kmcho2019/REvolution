module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // States: count of consecutive 1s after a zero: 0..6; 7 = error (7 or more 1s)
    // State encoding: 3 bits
    localparam S0 = 3'd0; // 0 consecutive 1s
    localparam S1 = 3'd1; // 1 consecutive 1
    localparam S2 = 3'd2;
    localparam S3 = 3'd3;
    localparam S4 = 3'd4;
    localparam S5 = 3'd5;
    localparam S6 = 3'd6;
    localparam S_ERR = 3'd7;

    reg [2:0] state, next_state;

    // Sequential state update
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            state <= next_state;

            // Output logic based on previous state and current input (Moore machine outputs depend on state only)
            // But outputs need to be asserted one cycle after condition occurs,
            // So we look at previous state and current input to generate outputs.

            // By observing transitions:
            // disc = output when previous state == S5 and input == 0 (means 5 consecutive 1s then a zero)
            // flag = output when previous state == S6 and input == 0 (6 consecutive 1s then zero)
            // err = output when previous state == S_ERR (7 or more consecutive ones)

            disc <= (state == S5) && (in == 0);
            flag <= (state == S6) && (in == 0);
            err <= (state == S_ERR);
        end
    end

    // Next state combinational logic
    always @(*) begin
        case(state)
            S0: begin
                if (in)
                    next_state = S1;
                else
                    next_state = S0;
            end
            S1: begin
                if (in)
                    next_state = S2;
                else
                    next_state = S0;
            end
            S2: begin
                if (in)
                    next_state = S3;
                else
                    next_state = S0;
            end
            S3: begin
                if (in)
                    next_state = S4;
                else
                    next_state = S0;
            end
            S4: begin
                if (in)
                    next_state = S5;
                else
                    next_state = S0;
            end
            S5: begin
                if (in)
                    next_state = S6;
                else
                    next_state = S0;
            end
            S6: begin
                if (in)
                    next_state = S_ERR; // 7 or more consecutive 1s
                else
                    next_state = S0;
            end
            S_ERR: begin
                // Remain in error state as long as input is 1 (still >=7 consecutive 1s)
                // Return to S0 if input is 0 (sequence broken)
                if (in)
                    next_state = S_ERR;
                else
                    next_state = S0;
            end
            default: next_state = S0;
        endcase
    end

endmodule