module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // State encoding with typedef for readability
    typedef enum reg [1:0] {
        IDLE      = 2'b00,
        RECEIVE   = 2'b01,
        STOP      = 2'b10,
        WAIT_STOP = 2'b11
    } state_t;

    state_t state, next_state;

    reg [2:0] bit_count;    // Counts 0 to 7 data bits
    reg [7:0] data_shift;

    reg done_next;

    // Next state and done combinational logic
    always @(*) begin
        done_next = 1'b0;
        next_state = state;
        case(state)
            IDLE: begin
                if (in == 1'b0)       // Start bit detected (falling edge from idle 1 to 0)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                if (bit_count == 3'd7)
                    next_state = STOP;
                else
                    next_state = RECEIVE;
            end

            STOP: begin
                if (in == 1'b1) begin
                    done_next = 1'b1;  // Valid stop bit
                    next_state = IDLE;
                end else begin
                    // Invalid stop bit, wait until line returns to idle (1)
                    next_state = WAIT_STOP;
                end
            end

            WAIT_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end

            default: next_state = IDLE;
        endcase
    end

    // State register
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Bit counter: increment during RECEIVE, reset otherwise
    always @(posedge clk) begin
        if (reset)
            bit_count <= 3'd0;
        else if (state == RECEIVE)
            bit_count <= bit_count + 3'd1;
        else
            bit_count <= 3'd0;
    end

    // Data shift register: shift in LSB first by shifting left and inserting new bit at LSB
    // This corresponds to data_shift = {data_shift[6:0], in}
    always @(posedge clk) begin
        if (reset)
            data_shift <= 8'd0;
        else if (state == RECEIVE)
            data_shift <= {data_shift[6:0], in};
        else if (state == IDLE)
            data_shift <= 8'd0;
    end

    // Output logic: latch out_byte and pulse done for one cycle on valid stop bit detection
    always @(posedge clk) begin
        if (reset) begin
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            done <= done_next;
            if (done_next)
                out_byte <= data_shift;
        end
    end

endmodule