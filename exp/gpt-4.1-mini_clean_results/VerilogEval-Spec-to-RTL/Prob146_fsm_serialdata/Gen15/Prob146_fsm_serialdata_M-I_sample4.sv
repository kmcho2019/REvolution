module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // One-hot state encoding for improved timing
    localparam IDLE       = 4'b0001;
    localparam RECEIVE    = 4'b0010;
    localparam STOP       = 4'b0100;
    localparam ERROR_WAIT = 4'b1000;

    reg [3:0] state, next_state;

    reg [2:0] bit_cnt;       // 0 to 7 bit counter
    reg [7:0] shift_reg;

    wire receiving = state[1]; // RECEIVE state bit
    wire stop_state = state[2]; // STOP state bit
    wire error_wait_state = state[3]; // ERROR_WAIT state bit

    // FSM state register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Bit counter with enable: increments only in RECEIVE state
    always @(posedge clk) begin
        if (reset)
            bit_cnt <= 3'd0;
        else if (receiving)
            bit_cnt <= bit_cnt + 3'd1;
        else
            bit_cnt <= 3'd0;
    end

    // Shift register: latch new bit into MSB position when bit_cnt increments (RECEIVE state)
    // This shifts data right by one each new bit received, inserting new bit at MSB
    // This implements LSB first serial reception
    always @(posedge clk) begin
        if (reset)
            shift_reg <= 8'd0;
        else if (state == IDLE)
            shift_reg <= 8'd0;
        else if (receiving)
            shift_reg <= {in, shift_reg[7:1]};
    end

    // done and out_byte register
    // done asserted 1 cycle on valid stop bit detection
    always @(posedge clk) begin
        if (reset) begin
            done <= 1'b0;
            out_byte <= 8'd0;
        end else begin
            done <= 1'b0; // default de-assert
            // Assert done only during STOP with valid stop bit (in=1)
            if (stop_state && in == 1'b1) begin
                done <= 1'b1;
                out_byte <= shift_reg;
            end
        end
    end

    // Next state logic combinational (one-hot states)
    always @(*) begin
        // Default: remain in current state
        next_state = state;
        case (state)
            IDLE: begin
                // Wait for start bit = 0
                if (in == 1'b0)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                // After 8 bits received (bit_cnt == 7), go to STOP
                if (bit_cnt == 3'd7)
                    next_state = STOP;
                else
                    next_state = RECEIVE;
            end

            STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;       // Valid stop bit, byte done
                else
                    next_state = ERROR_WAIT; // Invalid stop bit, wait for idle
            end

            ERROR_WAIT: begin
                if (in == 1'b1)
                    next_state = IDLE;       // Line idle returned
                else
                    next_state = ERROR_WAIT;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule