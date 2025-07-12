module TopModule (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

    // State encoding
    localparam [2:0] 
        IDLE   = 3'b000,
        ONE    = 3'b001,
        TWO    = 3'b010,
        THREE  = 3'b011,
        FOUR   = 3'b100,
        FIVE   = 3'b101,
        SIX    = 3'b110,
        ERROR  = 3'b111;

    reg [2:0] state, next_state;

    // State register
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
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

    // Output logic (registered)
    reg disc_reg, flag_reg, err_reg;

    always @(posedge clk) begin
        if (reset) begin
            disc_reg <= 0;
            flag_reg <= 0;
            err_reg <= 0;
        end else begin
            disc_reg <= (state == FIVE && !in);
            flag_reg <= (state == SIX && !in);
            err_reg <= (state == ERROR || (state == SIX && in));
        end
    end

    assign disc = disc_reg;
    assign flag = flag_reg;
    assign err = err_reg;

endmodule