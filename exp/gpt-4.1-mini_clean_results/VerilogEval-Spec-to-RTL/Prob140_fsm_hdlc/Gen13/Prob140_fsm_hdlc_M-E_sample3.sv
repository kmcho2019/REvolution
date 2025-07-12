module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // One-hot state encoding for count of consecutive ones 0..7 and error
    // state encoding: [8:0]
    // bit 0: count=0 (S0)
    // bit 1: count=1 (S1)
    // bit 2: count=2 (S2)
    // bit 3: count=3 (S3)
    // bit 4: count=4 (S4)
    // bit 5: count=5 (S5)
    // bit 6: count=6 (S6)
    // bit 7: count=7 error (S7)
    // bit 8: unused (kept zero)

    localparam integer S0 = 0;
    localparam integer S1 = 1;
    localparam integer S2 = 2;
    localparam integer S3 = 3;
    localparam integer S4 = 4;
    localparam integer S5 = 5;
    localparam integer S6 = 6;
    localparam integer S7 = 7; // error state

    reg [8:0] state, next_state;
    reg prev_in;

    // Initialize one-hot encoding for state: only one bit high at a time
    // so only state[Sx] = 1 means in state Sx

    // Next state logic combinational
    always @(*) begin
        // default next state: all zero to avoid latches
        next_state = 9'b0;
        case (1'b1) // one-hot decode
            state[S0]: begin
                if (in == 1'b0)
                    next_state[S0] = 1'b1;
                else
                    next_state[S1] = 1'b1;
            end
            state[S1]: begin
                if (in == 1'b0)
                    next_state[S0] = 1'b1;
                else
                    next_state[S2] = 1'b1;
            end
            state[S2]: begin
                if (in == 1'b0)
                    next_state[S0] = 1'b1;
                else
                    next_state[S3] = 1'b1;
            end
            state[S3]: begin
                if (in == 1'b0)
                    next_state[S0] = 1'b1;
                else
                    next_state[S4] = 1'b1;
            end
            state[S4]: begin
                if (in == 1'b0)
                    next_state[S0] = 1'b1;
                else
                    next_state[S5] = 1'b1;
            end
            state[S5]: begin
                if (in == 1'b0)
                    next_state[S0] = 1'b1;
                else
                    next_state[S6] = 1'b1;
            end
            state[S6]: begin
                if (in == 1'b0)
                    next_state[S0] = 1'b1;
                else
                    next_state[S7] = 1'b1; // error: 7 or more consecutive ones
            end
            state[S7]: begin
                if (in == 1'b0)
                    next_state[S0] = 1'b1;
                else
                    next_state[S7] = 1'b1;
            end
            default: begin
                // default safe state: count=0
                next_state[S0] = 1'b1;
            end
        endcase
    end

    // Outputs are Moore-type, depend only on current state and input history
    // disc: detected 0111110 = run of 5 ones followed by zero:
    // => currently in S5 (5 consecutive ones), previous in = 1, current in = 0
    wire disc_int = state[S5] && prev_in && (in == 1'b0);

    // flag: detected 01111110 = run of 6 ones followed by zero:
    // => currently in S6 (6 consecutive ones), previous in = 1, current in = 0
    wire flag_int = state[S6] && prev_in && (in == 1'b0);

    // err: when next state will be error state S7 (7 or more ones)
    wire err_int = next_state[S7];

    // Sequential logic: update state, prev_in and outputs
    always @(posedge clk) begin
        if (reset) begin
            state   <= 9'b1 << S0; // only S0 high
            prev_in <= 1'b0;
            disc    <= 1'b0;
            flag    <= 1'b0;
            err     <= 1'b0;
        end else begin
            state   <= next_state;
            prev_in <= in;
            disc    <= disc_int;
            flag    <= flag_int;
            err     <= err_int;
        end
    end

endmodule