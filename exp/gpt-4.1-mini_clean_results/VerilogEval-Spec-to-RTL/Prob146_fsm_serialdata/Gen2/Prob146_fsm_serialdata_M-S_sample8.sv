module TopModule (
    input        clk,
    input        in,
    input        reset,
    output reg [7:0] out_byte,
    output reg       done
);

    // State encoding
    localparam IDLE      = 2'd0;
    localparam RECEIVING = 2'd1;
    localparam WAIT_STOP = 2'd2;

    reg [1:0] state;
    reg [3:0] bit_count;
    reg [7:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            state      <= IDLE;
            bit_count  <= 4'd0;
            shift_reg  <= 8'd0;
            out_byte   <= 8'd0;
            done       <= 1'b0;
        end else begin
            done <= 1'b0;  // default done low

            case (state)
                IDLE: begin
                    if (in == 1'b0) begin
                        // Start bit detected, begin receiving data bits
                        state     <= RECEIVING;
                        bit_count <= 4'd0;
                        shift_reg <= 8'd0;
                    end
                end

                RECEIVING: begin
                    // Shift in the data bit LSB first
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count + 1'b1;

                    if (bit_count == 4'd7) begin
                        // Next bit is stop bit, so prepare to check stop bit next cycle
                        state <= WAIT_STOP;
                    end
                end

                WAIT_STOP: begin
                    if (in == 1'b1) begin
                        // Stop bit correct: output byte and signal done
                        out_byte <= shift_reg;
                        done     <= 1'b1;
                        state    <= IDLE;
                    end else begin
                        // Stop bit incorrect: wait here until stop bit detected to resync
                        state <= WAIT_STOP;
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule