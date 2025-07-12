module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // State encoding (4 bits):
    // 0-6: counts consecutive ones (0 to 6)
    // 7: disc output state (after detecting 5 ones + 0)
    // 8: flag output state (after detecting 6 ones + 0)
    // 9: err output state (7 or more ones detected)
    localparam 
        S0  = 4'd0,
        S1  = 4'd1,
        S2  = 4'd2,
        S3  = 4'd3,
        S4  = 4'd4,
        S5  = 4'd5,
        S6  = 4'd6,
        SD   = 4'd7,
        SF   = 4'd8,
        SE   = 4'd9;

    reg [3:0] state, next_state;

    // Next state logic combinational:
    always @(*) begin
        case (state)
            // Counting states 0..6:
            S0, S1, S2, S3, S4, S5, S6: begin
                if (in) begin
                    // Increment saturating at 7 (SE)
                    case (state)
                        S0: next_state = S1;
                        S1: next_state = S2;
                        S2: next_state = S3;
                        S3: next_state = S4;
                        S4: next_state = S5;
                        S5: next_state = S6;
                        S6: next_state = SE; // error state at 7 ones
                        default: next_state = S0; // safety
                    endcase
                end else begin
                    // on zero input after consecutive ones, decide outputs
                    case (state)
                        S5: next_state = SD; // disc output state
                        S6: next_state = SF; // flag output state
                        default: next_state = S0; // any other count -> reset count
                    endcase
                end
            end

            // Output states (one cycle output assertion)
            SD: begin
                // After disc output, transition based on input
                if (in)
                    next_state = S1; // start counting ones from 1
                else
                    next_state = S0;
            end

            SF: begin
                // After flag output, same logic
                if (in)
                    next_state = S1;
                else
                    next_state = S0;
            end

            SE: begin
                // Stay in error if input keeps 1, else reset count
                if (in)
                    next_state = SE;
                else
                    next_state = S0;
            end

            default: next_state = S0; // safety fallback
        endcase
    end

    // Sequential logic: state update and registered outputs
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            state <= next_state;

            // Outputs are asserted only during output states, otherwise zero
            disc <= (next_state == SD);
            flag <= (next_state == SF);
            err  <= (next_state == SE);
        end
    end

endmodule