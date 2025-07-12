module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // One-hot state encoding
    localparam IDLE    = 7'b0000001;
    localparam ONE_1   = 7'b0000010;
    localparam TWO_1   = 7'b0000100;
    localparam THREE_1 = 7'b0001000;
    localparam FOUR_1  = 7'b0010000;
    localparam FIVE_1  = 7'b0100000;
    localparam SIX_1   = 7'b1000000;

    reg [6:0] state, next_state;
    reg next_disc, next_flag, next_err;

    // State transition logic
    always @(*) begin
        next_state = IDLE;
        next_disc = 0;
        next_flag = 0;
        next_err = 0;

        case (state)
            IDLE:    next_state = in ? ONE_1 : IDLE;
            ONE_1:   next_state = in ? TWO_1 : IDLE;
            TWO_1:   next_state = in ? THREE_1 : IDLE;
            THREE_1: next_state = in ? FOUR_1 : IDLE;
            FOUR_1:  next_state = in ? FIVE_1 : IDLE;
            FIVE_1: begin
                if (in) next_state = SIX_1;
                else next_disc = 1;
            end
            SIX_1: begin
                if (in) begin
                    next_state = SIX_1;
                    next_err = 1;
                end else begin
                    next_state = IDLE;
                    next_flag = 1;
                end
            end
            default: next_state = IDLE;
        endcase
    end

    // State and output registers
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            state <= next_state;
            disc <= next_disc;
            flag <= next_flag;
            err <= next_err;
        end
    end

endmodule