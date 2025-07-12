module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // State encoding
    localparam IDLE       = 2'b00;
    localparam RECEIVE    = 2'b01;
    localparam CHECK_STOP = 2'b10;
    localparam WAIT_STOP  = 2'b11;

    reg [1:0] state;
    reg [2:0] bit_count;    // 0..7 for 8 data bits
    reg [7:0] shift_reg;

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
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                    if (in == 1'b0) begin  // start bit detected
                        state <= RECEIVE;
                    end else begin
                        state <= IDLE;
                    end
                end

                RECEIVE: begin
                    // Shift left by 1, input bit goes into LSB (LSB first serial)
                    shift_reg <= {shift_reg[6:0], in};
                    if (bit_count == 3'd7) begin
                        state <= CHECK_STOP;
                        bit_count <= 3'd0;
                    end else begin
                        bit_count <= bit_count + 1'b1;
                        state <= RECEIVE;
                    end
                end

                CHECK_STOP: begin
                    if (in == 1'b1) begin  // valid stop bit
                        done <= 1'b1;      // done pulse one cycle
                        state <= IDLE;
                    end else begin
                        // invalid stop bit, wait for stop bit
                        state <= WAIT_STOP;
                    end
                end

                WAIT_STOP: begin
                    if (in == 1'b1) begin  // wait until stop bit is observed
                        state <= IDLE;
                    end else begin
                        state <= WAIT_STOP;
                    end
                end

                default: begin
                    state     <= IDLE;
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                    done      <= 1'b0;
                end
            endcase
        end
    end

endmodule