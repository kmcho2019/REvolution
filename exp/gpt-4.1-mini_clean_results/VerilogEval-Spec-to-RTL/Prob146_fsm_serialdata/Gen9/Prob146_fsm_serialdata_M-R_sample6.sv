module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE      = 2'd0,
        RECEIVE   = 2'd1,
        STOP      = 2'd2,
        WAIT_STOP = 2'd3
    } state_t;

    state_t state, next_state;

    reg [7:0] data_shift;
    reg [2:0] bit_count;

    // Combinational next state logic
    always @(*) begin
        case (state)
            IDLE:    next_state = (in == 1'b0) ? RECEIVE : IDLE;
            RECEIVE: next_state = (bit_count == 3'd7) ? STOP : RECEIVE;
            STOP:    next_state = (in == 1'b1) ? IDLE : WAIT_STOP;
            WAIT_STOP: next_state = (in == 1'b1) ? IDLE : WAIT_STOP;
            default: next_state = IDLE;
        endcase
    end

    // Output signals and registers
    reg done_next;
    reg [7:0] out_byte_next;
    reg [7:0] data_shift_next;
    reg [2:0] bit_count_next;

    always @(*) begin
        // Defaults
        done_next = 1'b0;
        out_byte_next = out_byte;
        data_shift_next = data_shift;
        bit_count_next = bit_count;

        case (state)
            IDLE: begin
                if (in == 1'b0) begin
                    data_shift_next = 8'd0;
                    bit_count_next = 3'd0;
                end
            end

            RECEIVE: begin
                // Shift in LSB first
                data_shift_next = {in, data_shift[7:1]};
                bit_count_next = bit_count + 1;
            end

            STOP: begin
                if (in == 1'b1) begin
                    out_byte_next = data_shift;
                    done_next = 1'b1;
                end
            end

            WAIT_STOP: begin
                // Nothing changes; just wait for stop bit
            end
        endcase
    end

    // Sequential logic to update state and registers
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            data_shift <= 8'd0;
            bit_count <= 3'd0;
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            data_shift <= data_shift_next;
            bit_count <= bit_count_next;
            out_byte <= out_byte_next;
            done <= done_next;
        end
    end

endmodule