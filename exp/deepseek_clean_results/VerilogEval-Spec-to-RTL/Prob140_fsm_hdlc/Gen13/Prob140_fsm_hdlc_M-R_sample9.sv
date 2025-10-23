module TopModule (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

    // State encoding
    localparam IDLE    = 3'b000;
    localparam ONE     = 3'b001;
    localparam TWO     = 3'b010;
    localparam THREE   = 3'b011;
    localparam FOUR    = 3'b100;
    localparam FIVE    = 3'b101;
    localparam SIX     = 3'b110;
    localparam ERROR   = 3'b111;

    reg [2:0] state, next_state;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE:   next_state = in ? ONE : IDLE;
            ONE:    next_state = in ? TWO : IDLE;
            TWO:    next_state = in ? THREE : IDLE;
            THREE:  next_state = in ? FOUR : IDLE;
            FOUR:   next_state = in ? FIVE : IDLE;
            FIVE:   next_state = in ? SIX : (in ? ONE : IDLE);
            SIX:    next_state = in ? ERROR : (in ? ONE : IDLE);
            ERROR:  next_state = in ? ERROR : IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Output logic (combinational)
    assign disc = (state == FIVE) && !in;
    assign flag = (state == SIX) && !in;
    assign err  = (state == ERROR);

endmodule