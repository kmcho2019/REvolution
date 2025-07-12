module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

    // State encoding:
    // count_ones from 0 to 6 represent states S0 to S6 (consecutive ones count)
    // Special states:
    // SD = discard state (output disc)
    // SF = flag state (output flag)
    // SE = error state (output err)
    localparam [3:0]
        S0 = 4'd0,
        S1 = 4'd1,
        S2 = 4'd2,
        S3 = 4'd3,
        S4 = 4'd4,
        S5 = 4'd5,
        S6 = 4'd6,
        SD = 4'd7,
        SF = 4'd8,
        SE = 4'd9;

    reg [3:0] state, next_state;

    always @(*) begin
        case(state)
            // Counting consecutive ones from 0 to 6
            S0: begin
                if(in) next_state = S1; else next_state = S0;
            end
            S1: begin
                if(in) next_state = S2; else next_state = S0;
            end
            S2: begin
                if(in) next_state = S3; else next_state = S0;
            end
            S3: begin
                if(in) next_state = S4; else next_state = S0;
            end
            S4: begin
                if(in) next_state = S5; else next_state = S0;
            end
            S5: begin
                if(in) next_state = S6;
                else next_state = SD; // discard zero after 5 ones detected
            end
            S6: begin
                if(in) next_state = SE;  // error: 7 or more ones
                else next_state = SF;    // flag detected (6 ones + 0)
            end

            // Output states: disc, flag, err
            SD: begin
                // After discarding, go according to input (like after a zero)
                if(in) next_state = S1; else next_state = S0;
            end
            SF: begin
                // After flag, go according to input
                if(in) next_state = S1; else next_state = S0;
            end
            SE: begin
                // Error state stays until input zero resets count
                if(in) next_state = SE; else next_state = S0;
            end

            default: next_state = S0;
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Outputs asserted for one cycle after detection in dedicated states
    assign disc = (state == SD);
    assign flag = (state == SF);
    assign err  = (state == SE);

endmodule