module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // State encoding (2 bits) - binary FSM
    localparam IDLE       = 2'b00;
    localparam RECEIVE    = 2'b01;
    localparam STOP       = 2'b10;
    localparam ERROR_WAIT = 2'b11;

    reg [1:0] state, next_state;
    reg [2:0] bit_cnt;       // counts 0 to 7
    reg [7:0] shift_reg;

    wire receiving = (state == RECEIVE);

    // FSM state register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Bit counter: increments in RECEIVE, resets in IDLE and ERROR_WAIT
    always @(posedge clk) begin
        if (reset)
            bit_cnt <= 3'd0;
        else if (receiving)
            bit_cnt <= bit_cnt + 3'd1;
        else if (state == IDLE || state == ERROR_WAIT)
            bit_cnt <= 3'd0;
    end

    // Shift register shifts in LSB first (new bit at bit 0)
    always @(posedge clk) begin
        if (reset)
            shift_reg <= 8'd0;
        else if (state == IDLE)
            shift_reg <= 8'd0;
        else if (receiving)
            shift_reg <= {in, shift_reg[7:1]};
    end

    // done and out_byte registers: done asserted one cycle when valid stop bit seen
    always @(posedge clk) begin
        if (reset) begin
            done <= 1'b0;
            out_byte <= 8'd0;
        end else begin
            done <= 1'b0; // default de-assert
            if (state == STOP && in == 1'b1) begin
                done <= 1'b1;
                out_byte <= shift_reg;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                // Wait for start bit (0)
                if (in == 1'b0)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                // After receiving 8 bits (bit_cnt == 7), go to STOP
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