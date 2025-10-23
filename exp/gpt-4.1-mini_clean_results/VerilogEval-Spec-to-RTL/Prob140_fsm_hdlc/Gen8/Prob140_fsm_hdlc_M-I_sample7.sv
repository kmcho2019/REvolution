module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg disc,
    output reg flag,
    output reg err
);

    // One-hot encoded states for consecutive ones count plus special states:
    // S0  = 0000000001 (no ones)
    // S1  = 0000000010 (1 one)
    // S2  = 0000000100 (2 ones)
    // S3  = 0000001000 (3 ones)
    // S4  = 0000010000 (4 ones)
    // S5  = 0000100000 (5 ones)
    // SD  = 0001000000 (discard output state)
    // S6  = 0010000000 (6 ones)
    // SF  = 0100000000 (flag output state)
    // SE  = 1000000000 (error state >=7 ones)

    localparam [9:0]
        S0 = 10'b0000000001,
        S1 = 10'b0000000010,
        S2 = 10'b0000000100,
        S3 = 10'b0000001000,
        S4 = 10'b0000010000,
        S5 = 10'b0000100000,
        SD = 10'b0001000000,
        S6 = 10'b0010000000,
        SF = 10'b0100000000,
        SE = 10'b1000000000;

    reg [9:0] state, next_state;

    // Next state logic based on current state and input
    always @(*) begin
        // Default no outputs (will be set in sequential block)
        // Compute next_state purely combinational
        case (state)
            S0:    next_state = in ? S1 : S0;
            S1:    next_state = in ? S2 : S0;
            S2:    next_state = in ? S3 : S0;
            S3:    next_state = in ? S4 : S0;
            S4:    next_state = in ? S5 : S0;
            S5:    next_state = in ? S6 : SD; // disc on zero after 5 ones
            SD:    next_state = in ? S1 : S0; // after disc, restart count
            S6:    next_state = in ? SE : SF; // flag if zero after 6 ones, error if more ones
            SF:    next_state = in ? S1 : S0; // after flag, restart count
            SE:    next_state = in ? SE : S0; // stay error on ones, reset on zero
            default: next_state = S0;
        endcase
    end

    // Sequential state update and output registers
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc <= 1'b0;
            flag <= 1'b0;
            err  <= 1'b0;
        end else begin
            state <= next_state;
            // Set outputs based on next_state (Moore outputs)
            disc <= (next_state == SD);
            flag <= (next_state == SF);
            err  <= (next_state == SE);
        end
    end

endmodule