module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);
    // State encoding (binary)
    localparam IDLE       = 2'd0;
    localparam RECEIVE    = 2'd1;
    localparam CHECK_STOP = 2'd2;
    localparam WAIT_STOP  = 2'd3;

    reg [1:0] state, next_state;
    reg [7:0] shift_reg, next_shift_reg;
    reg [2:0] bit_cnt, next_bit_cnt;
    reg done_next;

    // Sequential block: state, counters, shift register, outputs update
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_cnt <= 3'd0;
            shift_reg <= 8'd0;
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            bit_cnt <= next_bit_cnt;
            shift_reg <= next_shift_reg;
            out_byte <= (done_next) ? shift_reg : out_byte; 
            done <= done_next;
        end
    end

    // Combinational block: next state logic and outputs
    always @(*) begin
        // Default assignments
        next_state = state;
        next_bit_cnt = bit_cnt;
        next_shift_reg = shift_reg;
        done_next = 1'b0;

        case (state)
            IDLE: begin
                if (in == 1'b0) begin
                    // Start bit detected, prepare to receive data bits
                    next_state = RECEIVE;
                    next_bit_cnt = 3'd0;
                    next_shift_reg = 8'd0;
                end
            end

            RECEIVE: begin
                // Shift in new bit (LSB first)
                next_shift_reg = {in, shift_reg[7:1]};
                if (bit_cnt == 3'd7) begin
                    next_state = CHECK_STOP;
                end else begin
                    next_bit_cnt = bit_cnt + 1;
                end
            end

            CHECK_STOP: begin
                if (in == 1'b1) begin
                    // Stop bit valid: output byte and signal done
                    done_next = 1'b1;
                    next_state = IDLE;
                end else begin
                    // Stop bit invalid: wait until line returns to 1
                    next_state = WAIT_STOP;
                end
            end

            WAIT_STOP: begin
                if (in == 1'b1) begin
                    // Stop bit found, back to IDLE
                    next_state = IDLE;
                end
            end

            default: begin
                next_state = IDLE;
            end
        endcase
    end

endmodule