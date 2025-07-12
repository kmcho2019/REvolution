module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // State encoding
    localparam S0   = 4'd0; // 0 consecutive ones
    localparam S1   = 4'd1; // 1 consecutive one
    localparam S2   = 4'd2; // 2 ones
    localparam S3   = 4'd3; // 3 ones
    localparam S4   = 4'd4; // 4 ones
    localparam S5   = 4'd5; // 5 ones
    localparam S6   = 4'd6; // 6 ones
    localparam DISC = 4'd7; // disc output asserted
    localparam FLAG = 4'd8; // flag output asserted
    localparam ERR  = 4'd9; // error output asserted (7 or more ones)

    reg [3:0] state, next_state;

    // Sequential logic: state update and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            state <= next_state;

            // Default outputs off
            disc <= 1'b0;
            flag <= 1'b0;
            err  <= 1'b0;

            // Assert outputs in dedicated output states (Moore outputs)
            case (state)
                DISC: disc <= 1'b1;
                FLAG: flag <= 1'b1;
                ERR:  err  <= 1'b1;
                default: ; // no output
            endcase
        end
    end

    // Combinational next-state logic
    always @(*) begin
        next_state = state; // default hold

        case (state)
            // Counting consecutive ones
            S0: next_state = in ? S1 : S0;

            S1: next_state = in ? S2 : S0;

            S2: next_state = in ? S3 : S0;

            S3: next_state = in ? S4 : S0;

            S4: next_state = in ? S5 : S0;

            S5: begin
                if (in)
                    next_state = S6; // sixth one
                else
                    next_state = DISC; // stuffed zero to discard detected after 5 ones
            end

            S6: begin
                if (in)
                    next_state = ERR;  // 7 consecutive ones = error
                else
                    next_state = FLAG; // flag detected (6 ones bounded by zeros)
            end

            // Output states assert signals for one clock cycle, then reset to S0
            DISC: next_state = S0;

            FLAG: next_state = S0;

            // Stay in error state while ones continue, reset on zero
            ERR: next_state = in ? ERR : S0;

            default: next_state = S0;
        endcase
    end

endmodule