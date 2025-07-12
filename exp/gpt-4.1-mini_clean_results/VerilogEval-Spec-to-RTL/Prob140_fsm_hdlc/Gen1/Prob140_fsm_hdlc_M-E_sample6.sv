module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // State encoding:
    // 0 to 6: count of consecutive ones
    // 7: discard output asserted (after zero following 5 ones)
    // 8: flag output asserted (after zero following 6 ones)
    // 9: error state (7 or more ones)
    typedef enum reg [3:0] {
        S0  = 4'd0,
        S1  = 4'd1,
        S2  = 4'd2,
        S3  = 4'd3,
        S4  = 4'd4,
        S5  = 4'd5,
        S6  = 4'd6,
        S5D = 4'd7, // disc output assertion
        S6F = 4'd8, // flag output assertion
        S7E = 4'd9  // error state
    } state_t;

    state_t state, next_state;

    // Sequential logic: state update and outputs
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            state <= next_state;

            // Default outputs
            disc <= 1'b0;
            flag <= 1'b0;
            err  <= 1'b0;

            // Assert outputs based on current state
            case (state)
                S5D: disc <= 1'b1;   // disc asserted for one cycle
                S6F: flag <= 1'b1;   // flag asserted for one cycle
                S7E: err  <= 1'b1;   // error asserted while in error state
                default: ; // no output
            endcase
        end
    end

    // Combinational next state logic
    always @(*) begin
        next_state = state; // default hold

        case (state)
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S2 : S0;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S4 : S0;
            S4: next_state = in ? S5 : S0;

            S5: if (in) next_state = S6; else next_state = S5D;
            S5D: next_state = S0;

            S6: if (in) next_state = S7E; else next_state = S6F;
            S6F: next_state = S0;

            S7E: if (in) next_state = S7E; else next_state = S0;

            default: next_state = S0;
        endcase
    end

endmodule