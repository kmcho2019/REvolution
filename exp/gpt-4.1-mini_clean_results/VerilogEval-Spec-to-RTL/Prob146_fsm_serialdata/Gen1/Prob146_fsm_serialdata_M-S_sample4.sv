module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    localparam IDLE = 2'd0, RECEIVE = 2'd1, STOP = 2'd2;

    reg [1:0] state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            done <= 1'b0; // default done low

            case(state)
                IDLE: begin
                    if (in == 1'b0) begin // start bit detected
                        state <= RECEIVE;
                        bit_count <= 3'd0;
                        shift_reg <= 8'd0;
                    end
                end

                RECEIVE: begin
                    // Shift bits left, insert new bit at LSB
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count + 1'b1;
                    if (bit_count == 3'd7) // after 8 bits
                        state <= STOP;
                end

                STOP: begin
                    if (in == 1'b1) begin // valid stop bit
                        out_byte <= shift_reg;
                        done <= 1'b1;
                        state <= IDLE;
                    end
                    // else stay in STOP waiting for stop bit
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule