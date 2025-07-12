module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg done
);

    // State encoding
    localparam IDLE      = 2'd0;
    localparam RECEIVE   = 2'd1;
    localparam WAIT_STOP = 2'd2;

    reg [1:0] state = IDLE;
    reg [2:0] bit_count = 3'd0;
    reg [7:0] shift_reg = 8'd0;

    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
            done      <= 1'b0;
        end else begin
            done <= 1'b0;  // default done low

            case (state)
                IDLE: begin
                    if (in == 1'b0) begin // start bit detected
                        state     <= RECEIVE;
                        bit_count <= 3'd0;
                        shift_reg <= 8'd0;
                    end
                end

                RECEIVE: begin
                    // Shift in bits LSB first by shifting right and placing new bit at MSB
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count + 1'b1;

                    if (bit_count == 3'd7) begin
                        // Next bit expected is stop bit (in)
                        if (in == 1'b1) begin
                            done  <= 1'b1;
                            state <= IDLE;
                        end else begin
                            state <= WAIT_STOP;
                        end
                        bit_count <= 3'd0;
                        shift_reg <= 8'd0;
                    end
                end

                WAIT_STOP: begin
                    // Wait for stop bit (logic 1)
                    if (in == 1'b1) begin
                        state <= IDLE;
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule