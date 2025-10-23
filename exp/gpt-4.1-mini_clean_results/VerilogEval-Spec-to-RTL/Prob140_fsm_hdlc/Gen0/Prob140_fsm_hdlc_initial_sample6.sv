module TopModule(
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // State encoding: counts number of consecutive ones after a zero.
    // S0 = zero last seen
    // S1..S6 = 1..6 consecutive ones
    // S7 = error state (7 or more ones)
    localparam S0 = 3'd0;
    localparam S1 = 3'd1;
    localparam S2 = 3'd2;
    localparam S3 = 3'd3;
    localparam S4 = 3'd4;
    localparam S5 = 3'd5;
    localparam S6 = 3'd6;
    localparam S7 = 3'd7; // error state

    reg [2:0] state, next_state;

    // Moore outputs depend on current state only

    always @(*) begin
        // Default outputs
        disc = 1'b0;
        flag = 1'b0;
        err  = 1'b0;

        case(state)
            S6: begin
                // If the current state is S6 and next input bit is zero, then
                // in the next cycle outputs should signal flag.
                // But outputs are Moore type, i.e. depend on current state only,
                // so outputs correspond to condition detected on previous cycle.

                // The problem states output should be asserted one cycle after condition occurs.
                // So we must assert outputs in states reached after input evaluated.

                // To do this properly, outputs depend on previous input and state,
                // but as a Moore FSM outputs depend only on current state.

                // We can encode outputs by introducing additional states to "remember" 
                // that the pattern occurred on previous cycle.

                // To keep FSM simple, let's move outputs to next state:

                // Therefore outputs for disc and flag and err will be asserted only on 
                // "post" states:

                // Instead, we will decode outputs on state:

                // The following encoding:
                // - disc asserted in state DISC (a new state after detecting 5 ones + 0)
                // - flag asserted in state FLAG (a new state after detecting 6 ones + 0)
                // - err asserted in state ERROR (state S7 or error post state)

                // So no outputs here.

                disc = 1'b0;
                flag = 1'b0;
                err  = 1'b0;
            end
            S7: begin
                err = 1'b1;
            end
            default: begin
                disc = 1'b0;
                flag = 1'b0;
                err  = 1'b0;
            end
        endcase
    end

    // Because outputs must be asserted one cycle after the condition occurs,
    // we create extra states for output assertion:

    // New states:
    // DISC: disc asserted one cycle after 5 consecutive 1s followed by 0
    // FLAG: flag asserted one cycle after 6 consecutive 1s followed by 0
    // ERROR_OUT: err asserted after error detected

    localparam DISC     = 3'd3; // Reuse S3? No, it's used for count=3, so extend encoding
    localparam FLAG_OUT = 3'd4;
    localparam ERROR_OUT= 3'd5;

    // We must redefine states to avoid overlap:

    // Use 4 bits for state to fit all states cleanly:

    reg [3:0] curr_state, nxt_state;

    localparam s0       = 4'd0;  // 0 consecutive ones
    localparam s1       = 4'd1;  // 1 consecutive one
    localparam s2       = 4'd2;
    localparam s3       = 4'd3;
    localparam s4       = 4'd4;
    localparam s5       = 4'd5;
    localparam s6       = 4'd6;
    localparam error    = 4'd7;  // 7 or more ones
    localparam disc_out = 4'd8;  // output disc asserted one cycle after 5 ones + 0
    localparam flag_out = 4'd9;  // output flag asserted one cycle after 6 ones + 0
    localparam err_out  = 4'd10; // output err asserted one cycle after error detected

    // New output logic:

    always @(*) begin
        disc = 1'b0;
        flag = 1'b0;
        err  = 1'b0;
        case(curr_state)
            disc_out: disc = 1'b1;
            flag_out: flag = 1'b1;
            err_out:  err  = 1'b1;
            default: begin end
        endcase
    end

    // Next state logic:

    always @(*) begin
        nxt_state = s0; // default

        case(curr_state)
            s0: begin
                if (in)
                    nxt_state = s1;
                else
                    nxt_state = s0;
            end
            s1: begin
                if (in)
                    nxt_state = s2;
                else
                    nxt_state = s0;
            end
            s2: begin
                if (in)
                    nxt_state = s3;
                else
                    nxt_state = s0;
            end
            s3: begin
                if (in)
                    nxt_state = s4;
                else
                    nxt_state = s0;
            end
            s4: begin
                if (in)
                    nxt_state = s5;
                else
                    nxt_state = s0;
            end
            s5: begin
                if (in)
                    nxt_state = s6;
                else
                    // 5 ones followed by zero means disc output next cycle
                    nxt_state = disc_out;
            end
            s6: begin
                if (in)
                    // 7 or more ones, error
                    nxt_state = error;
                else
                    // 6 ones followed by zero means flag output next cycle
                    nxt_state = flag_out;
            end
            error: begin
                // Remain in error state if input 1 continues
                // Or return to s0 if zero detected (resync)
                if (in)
                    nxt_state = error;
                else
                    nxt_state = err_out;
            end
            disc_out: begin
                // after disc output asserted for one cycle,
                // return to s0 if input zero else s1 if input 1
                if (in)
                    nxt_state = s1;
                else
                    nxt_state = s0;
            end
            flag_out: begin
                // after flag output asserted for one cycle,
                // return to s0 or s1 depending on input
                if (in)
                    nxt_state = s1;
                else
                    nxt_state = s0;
            end
            err_out: begin
                // after err output cycle, return to s0 or s1 depending on input
                if (in)
                    nxt_state = s1;
                else
                    nxt_state = s0;
            end
            default: nxt_state = s0;
        endcase
    end

    // State register with synchronous active high reset
    always @(posedge clk) begin
        if (reset)
            curr_state <= s0;
        else
            curr_state <= nxt_state;
    end

endmodule