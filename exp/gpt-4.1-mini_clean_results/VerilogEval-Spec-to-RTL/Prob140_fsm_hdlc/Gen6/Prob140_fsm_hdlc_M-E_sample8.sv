module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // One-hot state encoding: only one bit high to represent state
    // S0: no consecutive ones (last bit was zero)
    // S1..S6: count of consecutive ones
    // S7: error state (7 or more consecutive ones)
    reg [7:0] state, next_state;

    // State bits for readability
    wire S0 = state[0];
    wire S1 = state[1];
    wire S2 = state[2];
    wire S3 = state[3];
    wire S4 = state[4];
    wire S5 = state[5];
    wire S6 = state[6];
    wire S7 = state[7];

    always @(*) begin
        // Default: clear all next states
        next_state = 8'b0;
        
        // Transition logic based on current state and input
        case (1'b1) // priority decoder for one-hot current state
            S0: begin
                // If input=1, go to S1; else stay S0
                if (in)
                    next_state[1] = 1'b1; // S1
                else
                    next_state[0] = 1'b1; // S0
            end
            S1: begin
                // input=1 -> S2; else S0
                if (in)
                    next_state[2] = 1'b1;
                else
                    next_state[0] = 1'b1;
            end
            S2: begin
                if (in)
                    next_state[3] = 1'b1;
                else
                    next_state[0] = 1'b1;
            end
            S3: begin
                if (in)
                    next_state[4] = 1'b1;
                else
                    next_state[0] = 1'b1;
            end
            S4: begin
                if (in)
                    next_state[5] = 1'b1;
                else
                    next_state[0] = 1'b1;
            end
            S5: begin
                if (in)
                    next_state[6] = 1'b1;
                else
                    next_state[0] = 1'b1;
            end
            S6: begin
                if (in)
                    next_state[7] = 1'b1; // error state
                else
                    next_state[0] = 1'b1;
            end
            S7: begin
                // Stay in error while input = 1, else reset to S0
                if (in)
                    next_state[7] = 1'b1;
                else
                    next_state[0] = 1'b1;
            end
            default: next_state[0] = 1'b1; // safe default to S0
        endcase
    end

    // Registers to remember last cycle's transitions for output assertion
    reg disc_r, flag_r;

    always @(posedge clk) begin
        if (reset) begin
            state <= 8'b0000_0001; // S0
            disc <= 1'b0;
            flag <= 1'b0;
            err  <= 1'b0;
            disc_r <= 1'b0;
            flag_r <= 1'b0;
        end else begin
            state <= next_state;

            // Detect disc: previous state S5 and input=0, which means transition S5->S0
            // So disc_r = 1 if state was S5 and next_state is S0 in last cycle
            disc_r <= (S5 && !in);

            // Detect flag: previous state S6 and input=0, transition S6->S0
            flag_r <= (S6 && !in);

            // Outputs asserted one cycle after detection
            disc <= disc_r;
            flag <= flag_r;

            // err asserted when in error state (S7)
            err <= S7;
        end
    end

endmodule