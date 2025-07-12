module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // State encoding (binary)
    localparam IDLE       = 2'b00;
    localparam RECEIVE    = 2'b01;
    localparam CHECK_STOP = 2'b10;
    localparam WAIT_STOP  = 2'b11;

    reg [1:0] state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
            done <= 1'b0;
        end else begin
            done <= 1'b0;  // default done deassert

            case (state)
                IDLE: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                    if (in == 1'b0)
                        state <= RECEIVE;
                end
                RECEIVE: begin
                    // Shift in LSB first: new bit goes into MSB if we shift left,
                    // but problem wants LSB first, so shift right and insert bit at MSB or shift left and insert at LSB?
                    // Given the start bit is 0, and data bits sent LSB first, we can shift right and insert in MSB:
                    // but to align LSB first at LSB position, we shift right and insert input at MSB.
                    // Alternatively, shift left and insert input at LSB.
                    // To keep consistent with the problem: shift right, input at MSB.

                    // Actually, simpler: shift_reg <= {in, shift_reg[7:1]}; // new bit at MSB, shifting right
                    // This makes the first received bit stored at shift_reg[7], last at shift_reg[0],
                    // so bits are reversed, but problem does not specify output use.
                    // For simplicity, keep this.

                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count + 1'b1;

                    if (bit_count == 3'd7)
                        state <= CHECK_STOP;
                end
                CHECK_STOP: begin
                    if (in == 1'b1) begin
                        done <= 1'b1;
                        state <= IDLE;
                    end else begin
                        state <= WAIT_STOP;
                    end
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end
                WAIT_STOP: begin
                    if (in == 1'b1)
                        state <= IDLE;
                    // else remain in WAIT_STOP
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end
                default: begin
                    state <= IDLE;
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                    done <= 1'b0;
                end
            endcase
        end
    end

endmodule