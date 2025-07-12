module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // State encoding
    localparam IDLE      = 2'd0;
    localparam READ      = 2'd1;
    localparam WAIT_STOP = 2'd2;

    reg [1:0] state;
    reg [2:0] bit_cnt;       // 3-bit counter for 8 bits
    reg [7:0] data_shift;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_cnt <= 3'd0;
            data_shift <= 8'd0;
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            done <= 1'b0; // default done low

            case (state)
                IDLE: begin
                    bit_cnt <= 3'd0;
                    data_shift <= 8'd0;
                    if (in == 1'b0) // start bit detected
                        state <= READ;
                    else
                        state <= IDLE;
                end

                READ: begin
                    // Shift in LSB first: shift right and input bit into MSB
                    data_shift <= {in, data_shift[7:1]};
                    bit_cnt <= bit_cnt + 3'd1;

                    if (bit_cnt == 3'd7)
                        state <= WAIT_STOP;
                    else
                        state <= READ;
                end

                WAIT_STOP: begin
                    if (in == 1'b1) begin
                        out_byte <= data_shift;
                        done <= 1'b1;   // pulse done
                        state <= IDLE;
                    end else begin
                        // Invalid stop bit, wait for line to go high (idle)
                        state <= (in == 1'b1) ? IDLE : WAIT_STOP;
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule