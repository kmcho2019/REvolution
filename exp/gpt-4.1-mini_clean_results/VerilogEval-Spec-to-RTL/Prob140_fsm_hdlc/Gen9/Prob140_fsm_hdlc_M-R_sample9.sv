module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg disc,
    output reg flag,
    output reg err
);

    // One-hot state encoding:
    // Each bit represents the count of consecutive 1's seen (0 to 6),
    // plus three extra states for disc, flag, and error outputs.
    localparam
        S0  = 10'b0000000001, // 0 consecutive ones
        S1  = 10'b0000000010,
        S2  = 10'b0000000100,
        S3  = 10'b0000001000,
        S4  = 10'b0000010000,
        S5  = 10'b0000100000,
        S6  = 10'b0001000000,
        SD  = 10'b0010000000, // disc output state
        SF  = 10'b0100000000, // flag output state
        SE  = 10'b1000000000; // error state

    reg [9:0] state, next_state;

    // Next state logic combinational
    always @(*) begin
        disc = 1'b0;
        flag = 1'b0;
        err  = 1'b0;

        case (state)
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
                    next_state = SD; // disc output state after zero inserted after 5 ones
            end
            S6: begin
                if (in)
                    next_state = SE; // error state: 7 or more consecutive ones
                else
                    next_state = SF; // flag output state on 6 ones followed by zero
            end
            SD: begin
                // disc state outputs disc=1, then returns based on input
                disc = 1'b1;
                if (in)
                    next_state = S1;
                else
                    next_state = S0;
            end
            SF: begin
                // flag output asserted one cycle after flag pattern detected
                flag = 1'b1;
                if (in)
                    next_state = S1;
                else
                    next_state = S0;
            end
            SE: begin
                // error state outputs err=1 continuously if input remains 1
                err = 1'b1;
                if (in)
                    next_state = SE;
                else
                    next_state = S0;
            end
            default: begin
                next_state = S0;
            end
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

endmodule