module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // State encoding: counts number of consecutive 1's received.
    // 0: no consecutive ones (previous bit zero)
    // 1..5: counting 1..5 consecutive ones
    // 6: six consecutive ones detected (could be flag or error)
    // 7: error state for 7 or more ones
    localparam S0 = 3'd0,
               S1 = 3'd1,
               S2 = 3'd2,
               S3 = 3'd3,
               S4 = 3'd4,
               S5 = 3'd5,
               S6 = 3'd6,
               S7 = 3'd7; // error state: 7 or more ones

    reg [2:0] state, next_state;

    // Next state logic combinational
    always @(*) begin
        case (state)
            S0: next_state = in ? S1 : S0;

            S1: next_state = in ? S2 : S0;

            S2: next_state = in ? S3 : S0;

            S3: next_state = in ? S4 : S0;

            S4: next_state = in ? S5 : S0;

            S5: begin
                // From five consecutive ones, 
                // if input=0: detected 0111110 => discard bit (zero after five ones)
                // if input=1: move to six consecutive ones
                next_state = in ? S6 : S0;
            end

            S6: begin
                // From six consecutive ones,
                // if input=0: detected 01111110 => flag
                // if input=1: error state (7 or more ones)
                next_state = in ? S7 : S0;
            end

            S7: begin
                // In error state, remain here if input=1,
                // else back to zero count
                next_state = in ? S7 : S0;
            end

            default: next_state = S0;
        endcase
    end

    // Outputs registered, asserted for 1 cycle after detection (Moore outputs)
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            state <= next_state;

            // Default outputs low
            disc <= 1'b0;
            flag <= 1'b0;
            err  <= 1'b0;

            case (state)
                S5: if (~in) disc <= 1'b1;     // detected 0111110 (zero after 5 ones)
                S6: if (~in) flag <= 1'b1;     // detected 01111110 (flag)
                S7: err <= 1'b1;               // error (7 or more ones)
            endcase
        end
    end

endmodule