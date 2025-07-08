module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg disc,
    output reg flag,
    output reg err
);

    // State encoding: count of consecutive 1s seen, capped at 7 (7 means error)
    // States: 0 to 6 means count of consecutive ones so far
    // 7 means error state (7 or more ones)
    reg [3:0] state, next_state;

    // State definitions
    localparam S0 = 4'd0; // no consecutive ones
    localparam S1 = 4'd1; // 1 consecutive one
    localparam S2 = 4'd2;
    localparam S3 = 4'd3;
    localparam S4 = 4'd4;
    localparam S5 = 4'd5; // exactly five consecutive ones
    localparam S6 = 4'd6; // exactly six consecutive ones
    localparam S7 = 4'd7; // seven or more consecutive ones (error)

    // Next state logic combinational
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
                    next_state = S7; // 7 or more ones: error
                else
                    next_state = S0;
            end
            S7: begin
                if (in)
                    next_state = S7;
                else
                    next_state = S0;
            end
            default: next_state = S0;
        endcase
    end

    // Output registers, updated on clock with synchronous reset
    // Outputs are asserted for one cycle AFTER the condition occurs:
    // Condition occurs when state and input imply a detected pattern.
    // Because it is Moore FSM, outputs depend on state only.
    // So outputs will be generated based on previous state and current input.

    // To produce the output one cycle after condition occurs:
    // We generate outputs based on the *previous* state's transition and input.
    // So, store the previous state and input to generate outputs.

    reg [3:0] prev_state;
    reg       prev_in;

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            prev_state <= S0;
            prev_in <= 1'b0;
            disc <= 1'b0;
            flag <= 1'b0;
            err <= 1'b0;
        end else begin
            state <= next_state;
            prev_state <= state;
            prev_in <= in;

            // Clear outputs by default
            disc <= 1'b0;
            flag <= 1'b0;
            err <= 1'b0;

            // Check conditions based on prev_state and prev_in to assert outputs one cycle after detection

            // (1) disc: after 5 ones followed by a zero (input=0 when prev_state=5)
            // That means after detecting "0111110"
            if (prev_state == S5 && prev_in == 1'b0)
                disc <= 1'b1;

            // (2) flag: after 6 ones followed by a zero (input=0 when prev_state=6)
            // That means after detecting "01111110"
            else if (prev_state == S6 && prev_in == 1'b0)
                flag <= 1'b1;

            // (3) err: after 7 or more ones (prev_state=7)
            else if (prev_state == S7)
                err <= 1'b1;
        end
    end

endmodule