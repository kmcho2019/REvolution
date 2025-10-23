module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // Enumerated FSM states
    typedef enum logic [1:0] {
        IDLE       = 2'd0,
        RECEIVE    = 2'd1,
        STOP       = 2'd2,
        ERROR_WAIT = 2'd3
    } state_t;

    state_t state, next_state;

    reg [2:0] bit_cnt;
    reg [7:0] shift_reg;

    // FSM state register
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Bit counter with enable only in RECEIVE state
    always @(posedge clk) begin
        if (reset)
            bit_cnt <= 3'd0;
        else if (state == RECEIVE)
            bit_cnt <= bit_cnt + 3'd1;
        else
            bit_cnt <= 3'd0;
    end

    // Shift register update enabled only in RECEIVE state
    // Shift in LSB first: shift right, new bit into MSB (same as before)
    always @(posedge clk) begin
        if (reset)
            shift_reg <= 8'd0;
        else if (state == RECEIVE)
            shift_reg <= {in, shift_reg[7:1]};
        else if (state == IDLE)
            shift_reg <= 8'd0;
    end

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end
            RECEIVE: begin
                if (bit_cnt == 3'd7)
                    next_state = STOP;
                else
                    next_state = RECEIVE;
            end
            STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = ERROR_WAIT;
            end
            ERROR_WAIT: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = ERROR_WAIT;
            end
            default: next_state = IDLE;
        endcase
    end

    // Output and done signal (Moore output: depend only on state and input)
    always @(posedge clk) begin
        if (reset) begin
            done <= 1'b0;
            out_byte <= 8'd0;
        end else begin
            done <= 1'b0; // default no pulse
            if (state == STOP && in == 1'b1) begin
                done <= 1'b1;
                out_byte <= shift_reg;
            end
        end
    end

endmodule