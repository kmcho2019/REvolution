module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg done
);

    // State encoding
    localparam IDLE      = 3'd0;
    localparam START     = 3'd1;
    localparam DATA      = 3'd2;
    localparam STOP      = 3'd3;
    localparam WAIT_STOP = 3'd4;

    reg [2:0] state, next_state;
    reg [3:0] bit_count;    // To count 8 data bits
    reg [7:0] data_shift;   // Shift register for data bits

    // State transition and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            data_shift <= 8'd0;
            done <= 1'b0;
        end else begin
            done <= 1'b0; // Default done low

            case(state)
                IDLE: begin
                    if (in == 1'b0) begin
                        // Start bit detected
                        state <= START;
                    end else begin
                        state <= IDLE;
                    end
                end

                START: begin
                    // After seeing start bit, move to DATA to receive bits
                    bit_count <= 0;
                    data_shift <= 8'd0;
                    state <= DATA;
                end

                DATA: begin
                    // Shift in data bit (LSB first)
                    data_shift <= {in, data_shift[7:1]};
                    bit_count <= bit_count + 1'b1;
                    if (bit_count == 7) begin
                        // Received 8 data bits
                        state <= STOP;
                    end else begin
                        state <= DATA;
                    end
                end

                STOP: begin
                    if (in == 1'b1) begin
                        // Correct stop bit
                        done <= 1'b1; // Indicate byte received correctly
                        state <= IDLE;
                    end else begin
                        // Stop bit incorrect, wait for stop bit
                        state <= WAIT_STOP;
                    end
                end

                WAIT_STOP: begin
                    if (in == 1'b1) begin
                        // Stop bit found, go back to idle
                        state <= IDLE;
                    end else begin
                        state <= WAIT_STOP;
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule