module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    typedef enum logic [2:0] {
        IDLE = 3'd0,
        START_BIT = 3'd1,
        DATA_BITS = 3'd2,
        STOP_BIT = 3'd3,
        ERROR_STOP_WAIT = 3'd4
    } state_t;

    state_t state, next_state;

    reg [2:0] bit_count; // count 0 to 7 for data bits
    reg [7:0] data_shift;

    // State transition and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            data_shift <= 8'd0;
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            done <= 1'b0; // default no done pulse
            case(state)
                IDLE: begin
                    if (in == 1'b0) begin
                        // start bit detected
                        state <= DATA_BITS;
                        bit_count <= 3'd0;
                        data_shift <= 8'd0;
                    end else begin
                        state <= IDLE;
                    end
                end
                DATA_BITS: begin
                    // shift in data bits LSB first
                    data_shift[bit_count] <= in;
                    if (bit_count == 3'd7) begin
                        state <= STOP_BIT;
                    end else begin
                        bit_count <= bit_count + 1;
                    end
                end
                STOP_BIT: begin
                    if (in == 1'b1) begin
                        // stop bit correct
                        out_byte <= data_shift;
                        done <= 1'b1;
                        state <= IDLE;
                    end else begin
                        // stop bit error, go wait for next stop bit
                        state <= ERROR_STOP_WAIT;
                    end
                end
                ERROR_STOP_WAIT: begin
                    // wait until line goes high (stop bit)
                    if (in == 1'b1) begin
                        // recovered, can try new byte
                        state <= IDLE;
                    end else begin
                        state <= ERROR_STOP_WAIT;
                    end
                end
                default: state <= IDLE;
            endcase
        end
    end

endmodule