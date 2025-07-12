module TopModule (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

    // State encoding with outputs embedded (binary encoding)
    // [3:1] - state, [0] - unused (could be used for future expansion)
    // Output encoding:
    // disc = state[3] & ~state[2] & state[1] & ~state[0]  // 1010
    // flag = state[3] & ~state[2] & state[1] & state[0]    // 1011
    // err  = state[3] & state[2] & ~state[1] & ~state[0]   // 1100
    localparam INIT     = 4'b0000;
    localparam ONE      = 4'b0001;
    localparam TWO      = 4'b0010;
    localparam THREE    = 4'b0011;
    localparam FOUR     = 4'b0100;
    localparam FIVE     = 4'b0101;
    localparam SIX_ONES = 4'b0110;
    localparam DISC     = 4'b1010;
    localparam FLAG     = 4'b1011;
    localparam ERR      = 4'b1100;

    reg [3:0] state, next_state;

    // Output logic (direct from state bits)
    assign disc = (state == DISC);
    assign flag = (state == FLAG);
    assign err  = (state == ERR);

    // Optimized state transition logic
    always @(*) begin
        case (state)
            INIT:     next_state = in ? ONE : INIT;
            ONE:      next_state = in ? TWO : INIT;
            TWO:      next_state = in ? THREE : INIT;
            THREE:    next_state = in ? FOUR : INIT;
            FOUR:     next_state = in ? FIVE : INIT;
            FIVE:     next_state = in ? SIX_ONES : DISC;
            SIX_ONES: next_state = in ? ERR : FLAG;
            DISC:     next_state = in ? ONE : INIT;
            FLAG:     next_state = in ? ONE : INIT;
            ERR:      next_state = in ? ERR : INIT;
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