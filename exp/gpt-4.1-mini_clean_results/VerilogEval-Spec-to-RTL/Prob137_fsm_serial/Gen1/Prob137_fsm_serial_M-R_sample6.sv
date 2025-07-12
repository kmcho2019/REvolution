module TopModule(
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    typedef enum reg [1:0] {
        IDLE      = 2'd0,
        RECEIVING = 2'd1,
        WAIT_STOP = 2'd2
    } state_t;

    reg [3:0] bit_count; // 0 to 9 (start bit + 8 data bits + stop bit)
    reg [7:0] data_shift; // for completeness, not required to output
    reg [1:0] state, next_state;

    // Sequential logic: state transitions, bit_count, done generation
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 4'd0;
            done      <= 1'b0;
            data_shift <= 8'd0;
        end else begin
            done <= 1'b0; // default no done output

            case (state)
                IDLE: begin
                    bit_count <= 4'd0;
                    data_shift <= 8'd0;
                    if (in == 1'b0) begin
                        // Detected start bit
                        state <= RECEIVING;
                        bit_count <= 4'd0;
                    end
                end

                RECEIVING: begin
                    bit_count <= bit_count + 4'd1;
                    if (bit_count >= 1 && bit_count <= 8) begin
                        // Shift in data bits, LSB first
                        data_shift <= {in, data_shift[7:1]};
                    end

                    if (bit_count == 4'd9) begin
                        // Stop bit expected here
                        if (in == 1'b1) begin
                            // Correct stop bit, signal done
                            done <= 1'b1;
                            state <= IDLE;
                            bit_count <= 4'd0;
                        end else begin
                            // Incorrect stop bit, enter wait state
                            state <= WAIT_STOP;
                            bit_count <= 4'd0;
                        end
                    end
                end

                WAIT_STOP: begin
                    if (in == 1'b1) begin
                        // Stop bit found; return to IDLE to await next start bit
                        state <= IDLE;
                        bit_count <= 4'd0;
                    end
                    // else remain in WAIT_STOP until in==1
                end

                default: begin
                    // Safe fallback
                    state <= IDLE;
                    bit_count <= 4'd0;
                    done <= 1'b0;
                end
            endcase
        end
    end

endmodule