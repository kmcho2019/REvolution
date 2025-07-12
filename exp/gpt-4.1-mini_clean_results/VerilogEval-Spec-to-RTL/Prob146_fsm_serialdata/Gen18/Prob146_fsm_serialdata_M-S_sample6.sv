module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // FSM states
    localparam IDLE       = 2'd0,
               RECEIVE    = 2'd1,
               CHECK_STOP = 2'd2;

    reg [1:0] state;
    reg [2:0] bit_cnt;
    reg [7:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_cnt   <= 3'd0;
            shift_reg <= 8'd0;
            done      <= 1'b0;
            out_byte  <= 8'd0;
        end else begin
            done <= 1'b0; // default done low

            case (state)
                IDLE: begin
                    bit_cnt <= 3'd0;
                    if (in == 1'b0) // start bit detected
                        state <= RECEIVE;
                end

                RECEIVE: begin
                    // Shift right, MSB gets new bit (LSB first serial)
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_cnt <= bit_cnt + 3'd1;
                    if (bit_cnt == 3'd7)
                        state <= CHECK_STOP;
                end

                CHECK_STOP: begin
                    if (in == 1'b1) begin
                        // Valid stop bit
                        done <= 1'b1;
                        out_byte <= shift_reg;
                        state <= IDLE;
                    end
                    // else stay in CHECK_STOP waiting for stop bit
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule