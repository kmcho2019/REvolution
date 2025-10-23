module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // One-hot states: S0..S7 (8 states)
    // S0: zero consecutive ones
    // S1..S6: 1..6 consecutive ones
    // S7: error (7 or more consecutive ones)
    reg [7:0] state, next_state;

    // Synchronous reset and state register update
    always @(posedge clk) begin
        if (reset) begin
            state <= 8'b0000_0001; // S0 active
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            state <= next_state;

            // Outputs registered for one cycle after detection
            // disc: input=0 and previous state was S5 (5 consecutive ones)
            // flag: input=0 and previous state was S6 (6 consecutive ones)
            // err: entering state S7 (error)
            disc <= (state[5] && (in == 1'b0));  // S5 active and input zero
            flag <= (state[6] && (in == 1'b0));  // S6 active and input zero
            err  <= next_state[7];                // entering error state
        end
    end

    // Next-state combinational logic
    // On input 0: next state = S0 except from error S7 which stays in error or resets to S0 on 0
    // On input 1: move to next consecutive one state (shift left by one)
    // If already in error, stay or reset on zero
    always @(*) begin
        case (in)
            1'b0: begin
                // Input zero resets count to S0 (except error handled separately)
                if (state[7]) // error state
                    next_state = 8'b0000_0001; // reset to S0 on zero input
                else
                    next_state = 8'b0000_0001; // S0 active
            end
            1'b1: begin
                // Input one: shift count of consecutive ones left
                if      (state[7]) next_state = 8'b1000_0000; // stay in error
                else if (state[6]) next_state = 8'b1000_0000; // move to error S7 on next one
                else if (state[5]) next_state = 8'b0100_0000; // move from S5 to S6
                else if (state[4]) next_state = 8'b0010_0000; // S4 to S5
                else if (state[3]) next_state = 8'b0001_0000; // S3 to S4
                else if (state[2]) next_state = 8'b0000_1000; // S2 to S3
                else if (state[1]) next_state = 8'b0000_0100; // S1 to S2
                else if (state[0]) next_state = 8'b0000_0010; // S0 to S1
                else              next_state = 8'b0000_0001; // default to S0 (should not happen)
            end
            default: next_state = 8'b0000_0001; // default S0
        endcase
    end

endmodule