module TopModule(
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output shift_ena,
    output counting,
    output done
);

    // State encoding
    typedef enum logic [2:0] {
        IDLE     = 3'd0,
        SHIFT_0  = 3'd1,
        SHIFT_1  = 3'd2,
        SHIFT_2  = 3'd3,
        SHIFT_3  = 3'd4,
        COUNTING = 3'd5,
        DONE     = 3'd6
    } state_t;

    state_t state, next_state;
    reg [3:0] shift_reg;

    localparam [3:0] PATTERN = 4'b1101;

    // Sequential block: state and shift_reg update
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            shift_reg <= 4'b0000;
        end else begin
            // Shift in data every clock cycle
            shift_reg <= {shift_reg[2:0], data};
            state <= next_state;
        end
    end

    // Combinational next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                // Transition only if current shift_reg matches pattern
                if (shift_reg == PATTERN)
                    next_state = SHIFT_0;
            end
            SHIFT_0: next_state = SHIFT_1;
            SHIFT_1: next_state = SHIFT_2;
            SHIFT_2: next_state = SHIFT_3;
            SHIFT_3: next_state = COUNTING;
            COUNTING: if (done_counting) next_state = DONE;
            DONE: if (ack) next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Output signals driven combinationally from current state
    assign shift_ena = (state == SHIFT_0) || (state == SHIFT_1) || (state == SHIFT_2) || (state == SHIFT_3);
    assign counting  = (state == COUNTING);
    assign done      = (state == DONE);

endmodule