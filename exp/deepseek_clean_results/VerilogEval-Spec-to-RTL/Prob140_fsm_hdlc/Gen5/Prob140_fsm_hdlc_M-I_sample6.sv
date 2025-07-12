module TopModule (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

    // State encoding
    localparam INIT     = 0;
    localparam ONE      = 1;
    localparam TWO      = 2;
    localparam THREE    = 3;
    localparam FOUR     = 4;
    localparam FIVE     = 5;
    localparam SIX_ONES = 6;
    localparam DISC     = 7;
    localparam FLAG     = 8;
    localparam ERR      = 9;

    reg [3:0] state, next_state;

    // Output logic (Moore machine)
    assign disc = (state == DISC);
    assign flag = (state == FLAG);
    assign err  = (state == ERR);

    // State transition logic
    always @(*) begin
        case (state)
            INIT: next_state = in ? ONE : INIT;
            ONE:  next_state = in ? TWO : INIT;
            TWO:  next_state = in ? THREE : INIT;
            THREE: next_state = in ? FOUR : INIT;
            FOUR: next_state = in ? FIVE : INIT;
            FIVE: next_state = in ? SIX_ONES : DISC;
            SIX_ONES: next_state = in ? ERR : FLAG;
            DISC: next_state = in ? ONE : INIT;
            FLAG: next_state = in ? ONE : INIT;
            ERR:  next_state = in ? ERR : INIT;
            default: next_state = INIT;
        endcase
    end

    // State register
    always @(posedge clk) begin
        if (reset) begin
            state <= INIT;
        end else begin
            state <= next_state;
        end
    end

endmodule