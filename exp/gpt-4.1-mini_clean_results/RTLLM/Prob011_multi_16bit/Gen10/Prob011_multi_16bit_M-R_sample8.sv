module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

    typedef enum logic [1:0] {IDLE=2'b00, LOAD=2'b01, CALC=2'b10, DONE=2'b11} state_t;
    state_t state, next_state;

    reg [4:0] shift_count;
    reg [15:0] multiplicand;
    reg [15:0] multiplier;
    reg [31:0] accumulator;
    reg done_r;

    // State transition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case(state)
            IDLE:   next_state = start ? LOAD : IDLE;
            LOAD:   next_state = CALC;
            CALC:   next_state = (shift_count == 5'd16) ? DONE : CALC;
            DONE:   next_state = start ? LOAD : IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Shift count logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            shift_count <= 5'd0;
        else if (state == LOAD)
            shift_count <= 5'd0;
        else if (state == CALC)
            shift_count <= shift_count + 5'd1;
        else
            shift_count <= 5'd0;
    end

    // Registers update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            multiplicand <= 16'd0;
            multiplier   <= 16'd0;
            accumulator  <= 32'd0;
            done_r       <= 1'b0;
        end else begin
            case(state)
                IDLE: begin
                    accumulator <= 32'd0;
                    done_r <= 1'b0;
                end
                LOAD: begin
                    multiplicand <= ain;
                    multiplier   <= bin;
                    accumulator  <= 32'd0;
                    done_r <= 1'b0;
                end
                CALC: begin
                    // Check current bit of multiplicand at shift_count position
                    if (multiplicand[shift_count])
                        accumulator <= accumulator + ( {16'd0, multiplier} << shift_count );
                end
                DONE: begin
                    done_r <= 1'b1;
                end
            endcase
        end
    end

    assign yout = accumulator;
    assign done = done_r;

endmodule