module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // State encoding
    typedef enum reg [1:0] {
        IDLE = 2'd0,
        DATA = 2'd1,
        STOP = 2'd2,
        WAIT_STOP = 2'd3
    } state_t;

    reg [2:0] bit_count;   // Counts bits received (0 to 7)
    reg [7:0] data_reg;    // Shift register for received data bits
    reg [1:0] state, next_state;

    // State register
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            data_reg <= 8'd0;
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0; // default done to 0, will set to 1 when done
            case (state)
                IDLE: begin
                    if (in == 1'b0) begin // start bit detected
                        bit_count <= 3'd0;
                    end
                end
                DATA: begin
                    // shift in data bits LSB first
                    data_reg <= {in, data_reg[7:1]};
                    bit_count <= bit_count + 1;
                end
                STOP: begin
                    // No data to shift, check stop bit
                    if (in == 1'b1) begin
                        out_byte <= data_reg;
                        done <= 1'b1;
                    end
                end
                WAIT_STOP: begin
                    // Waiting for line to go high again
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = DATA;
                else
                    next_state = IDLE;
            end
            DATA: begin
                if (bit_count == 3'd7)
                    next_state = STOP;
                else
                    next_state = DATA;
            end
            STOP: begin
                if (in == 1'b1)
                    next_state = IDLE; // valid stop bit, ready for next byte
                else
                    next_state = WAIT_STOP; // invalid stop bit
            end
            WAIT_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE; // wait until stop bit appears
                else
                    next_state = WAIT_STOP;
            end
        endcase
    end

endmodule