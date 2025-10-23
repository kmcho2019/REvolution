module TopModule(
    input  wire clk,
    input  wire reset,
    input  wire data,
    input  wire done_counting,
    input  wire ack,
    output wire shift_ena,
    output wire counting,
    output wire done
);

    // State encoding
    typedef enum logic [2:0] {
        IDLE       = 3'd0,
        SHIFT_0    = 3'd1,
        SHIFT_1    = 3'd2,
        SHIFT_2    = 3'd3,
        SHIFT_3    = 3'd4,
        WAIT_COUNT = 3'd5,
        WAIT_ACK   = 3'd6
    } state_t;

    state_t state, next_state;

    reg [3:0] pattern_reg;

    // Update pattern register every clock to detect pattern 1101 immediately
    always @(posedge clk) begin
        if (reset)
            pattern_reg <= 4'b0000;
        else
            pattern_reg <= {pattern_reg[2:0], data};
    end

    // State transition logic (combinational)
    always @(*) begin
        next_state = state;
        case(state)
            IDLE: begin
                if (pattern_reg == 4'b1101)
                    next_state = SHIFT_0;
            end
            SHIFT_0: next_state = SHIFT_1;
            SHIFT_1: next_state = SHIFT_2;
            SHIFT_2: next_state = SHIFT_3;
            SHIFT_3: next_state = WAIT_COUNT;
            WAIT_COUNT: begin
                if (done_counting)
                    next_state = WAIT_ACK;
            end
            WAIT_ACK: begin
                if (ack)
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // State register (sequential)
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Outputs driven combinationally (Moore machine style)
    assign shift_ena = (state == SHIFT_0) || (state == SHIFT_1) || (state == SHIFT_2) || (state == SHIFT_3);
    assign counting  = (state == WAIT_COUNT);
    assign done      = (state == WAIT_ACK);

endmodule