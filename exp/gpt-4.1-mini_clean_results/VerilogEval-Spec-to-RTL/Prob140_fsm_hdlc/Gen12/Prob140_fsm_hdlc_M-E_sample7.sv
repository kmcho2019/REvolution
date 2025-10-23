module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // Enumerated states for counts of consecutive 1s
    typedef enum reg [3:0] {
        S0 = 4'd0,  // zero consecutive ones
        S1 = 4'd1,
        S2 = 4'd2,
        S3 = 4'd3,
        S4 = 4'd4,
        S5 = 4'd5,
        S6 = 4'd6,
        S7 = 4'd7,  // seven or more consecutive ones (error)
        SERR = 4'd8 // explicit error state
    } state_t;

    reg [3:0] state, next_state;

    // Moore outputs depend on current state and input
    // Outputs are asserted one clock cycle after condition occurs,
    // so outputs depend on current state and input will determine next state.

    always @(*) begin
        // default outputs
        disc = 1'b0;
        flag = 1'b0;
        err  = 1'b0;
        next_state = S0; // default transition

        case (state)
            S0: begin
                if (in)
                    next_state = S1;
                else
                    next_state = S0;
                // No outputs in S0
            end
            S1: begin
                if (in)
                    next_state = S2;
                else begin
                    // detected 1 consecutive ones ended by zero, no special output
                    next_state = S0;
                end
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
                else begin
                    // 5 consecutive ones ended by zero, disc output
                    disc = 1'b1;
                    next_state = S0;
                end
            end
            S6: begin
                if (in)
                    next_state = S7;
                else begin
                    // 6 consecutive ones ended by zero, flag output
                    flag = 1'b1;
                    next_state = S0;
                end
            end
            S7: begin
                // 7 or more consecutive ones = error
                err = 1'b1;
                // Stay in error state if more ones; reset on zero input
                if (in)
                    next_state = SERR;
                else
                    next_state = S0;
            end
            SERR: begin
                // Remain in error state if ones persist
                err = 1'b1;
                if (in)
                    next_state = SERR;
                else
                    next_state = S0;
            end
            default: begin
                next_state = S0;
            end
        endcase
    end

    // Sequential logic for state and outputs, synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            state <= next_state;

            // Outputs latched one cycle after detection:
            // The outputs computed combinationally above are driven from state/input,
            // so to assert for one cycle after detection, register disc/flag/err here.
            // The combinational block sets outputs only for zero-input transitions;
            // at states S7 and SERR, err is high continuously if input=1.

            // Since outputs are computed combinationally above, 
            // and output registers are driven by those values, 
            // the logic is correct to hold outputs one cycle.

            // (No extra logic needed here since disc,flag,err assigned combinationally)
        end
    end

endmodule