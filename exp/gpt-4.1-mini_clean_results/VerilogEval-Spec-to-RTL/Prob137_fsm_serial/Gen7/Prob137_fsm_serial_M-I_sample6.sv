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

    // Enable signals for registers to reduce toggling
    wire shift_en = (state == RECEIVE);
    wire count_en = (state == RECEIVE);

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
                    if (shift_en) begin
                        // Shift in LSB first, insert new bit at MSB after right shift
                        shift_reg <= {in, shift_reg[7:1]};
                    end
                    if (count_en) begin
                        bit_count <= bit_count + 1'b1;
                    end

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
                    // Reset bit_count and shift_reg only here after byte done or error
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end
                WAIT_STOP: begin
                    if (in == 1'b1)
                        state <= IDLE;
                    // No reset of bit_count or shift_reg here to avoid extra toggling
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