module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // State encoding
    localparam IDLE      = 2'd0;
    localparam RECEIVE   = 2'd1;
    localparam STOP      = 2'd2;
    localparam WAIT_STOP = 2'd3;

    reg [1:0] state, next_state;
    reg [2:0] bit_count; // to count 8 bits (0 to 7)
    reg [7:0] data_shift;

    // Sequential logic with clock enables
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            data_shift <= 8'd0;
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            done <= 1'b0;  // default no done signal

            case (state)
                IDLE: begin
                    // No updates to bit_count or data_shift except on detecting start bit
                    if (in == 1'b0) begin
                        bit_count <= 3'd0;
                        data_shift <= 8'd0;
                    end
                end

                RECEIVE: begin
                    // Update data_shift and bit_count only in RECEIVE state to reduce switching
                    data_shift <= {in, data_shift[7:1]};  // LSB first shifting in 'in'
                    bit_count <= bit_count + 1;
                end

                STOP: begin
                    // Check stop bit
                    if (in == 1'b1) begin
                        out_byte <= data_shift;
                        done <= 1'b1;
                    end
                    // bit_count and data_shift hold value here
                end

                WAIT_STOP: begin
                    // Hold data_shift and bit_count steady, wait for stop bit to return high
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = RECEIVE; // start bit detected
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
                if (in == 1'b1)
                    next_state = IDLE;  // correct stop bit, go back to idle
                else
                    next_state = WAIT_STOP; // bad stop bit, wait for line return to idle
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

endmodule