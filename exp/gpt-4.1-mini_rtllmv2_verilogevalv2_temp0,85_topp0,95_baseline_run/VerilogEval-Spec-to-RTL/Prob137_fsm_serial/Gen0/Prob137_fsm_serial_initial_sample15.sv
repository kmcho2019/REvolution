module TopModule (
    input clk,
    input reset,
    input in,
    output reg done
);

    typedef enum reg [2:0] {
        IDLE = 3'd0,
        START = 3'd1,
        DATA = 3'd2,
        STOP = 3'd3,
        ERROR = 3'd4
    } state_t;

    reg [2:0] state, next_state;
    reg [3:0] bit_count; // counts 0 to 7 for 8 data bits
    reg [7:0] data_shift;

    // Sequential state and data registers
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 4'd0;
            data_shift <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0; // done pulses only one cycle when stop bit correct

            case (state)
                IDLE: begin
                    if (in == 1'b0) begin
                        // start bit detected
                        bit_count <= 4'd0;
                    end
                end
                START: begin
                    // nothing to shift, just wait for next bit
                end
                DATA: begin
                    // shift in LSB first
                    data_shift <= {in, data_shift[7:1]};
                    bit_count <= bit_count + 1;
                end
                STOP: begin
                    // no shift, just check stop bit
                end
                ERROR: begin
                    // no shift
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                done = 1'b0;
                if (!reset) begin
                    if (in == 1'b0)
                        next_state = START;
                    else
                        next_state = IDLE;
                end
            end
            START: begin
                // After seeing start bit, move to DATA on next cycle
                next_state = DATA;
            end
            DATA: begin
                if (bit_count == 4'd7)
                    next_state = STOP;
                else
                    next_state = DATA;
            end
            STOP: begin
                if (in == 1'b1) begin
                    next_state = IDLE;
                end else begin
                    next_state = ERROR;
                end
            end
            ERROR: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = ERROR;
            end
        endcase
    end

    // done pulse generation - set done high for one cycle when stop bit correct
    always @(posedge clk) begin
        if (reset) begin
            done <= 1'b0;
        end else if (state == STOP && in == 1'b1) begin
            done <= 1'b1;
        end else begin
            done <= 1'b0;
        end
    end

endmodule