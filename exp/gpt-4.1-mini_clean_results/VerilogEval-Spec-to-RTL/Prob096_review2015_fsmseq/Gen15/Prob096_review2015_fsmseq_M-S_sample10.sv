module TopModule(
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

    // States encode how many bits of '1101' matched so far
    localparam [2:0]
        IDLE = 3'b000,  // no match yet
        ONE  = 3'b001,  // matched '1'
        TWO  = 3'b010,  // matched '11'
        THREE= 3'b011,  // matched '110'
        DONE = 3'b100;  // matched '1101' sequence detected

    reg [2:0] state, next_state;

    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    always @(*) begin
        case (state)
            IDLE:   next_state = data ? ONE  : IDLE;
            ONE:    next_state = data ? TWO  : IDLE;
            TWO:    next_state = data ? TWO  : THREE;
            THREE:  next_state = data ? DONE : IDLE;
            DONE:   next_state = DONE;
            default: next_state = IDLE;
        endcase
    end

    assign start_shifting = (state == DONE);

endmodule