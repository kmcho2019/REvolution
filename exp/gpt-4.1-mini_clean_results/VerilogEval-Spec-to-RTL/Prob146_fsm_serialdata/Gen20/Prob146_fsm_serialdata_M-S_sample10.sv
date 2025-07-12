module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // State encoding (binary)
    localparam IDLE       = 2'd0,
               RECEIVE    = 2'd1,
               CHECK_STOP = 2'd2,
               RECOVER    = 2'd3;

    reg [1:0] state, next_state;
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
            state <= next_state;

            done <= 1'b0;  // default done low

            case (state)
                IDLE: begin
                    bit_cnt <= 3'd0;
                    shift_reg <= 8'd0;
                end

                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]}; // shift right, LSB first in bit 0
                    bit_cnt <= bit_cnt + 1'b1;
                end

                CHECK_STOP: begin
                    bit_cnt <= 3'd0;
                    if (in == 1'b1) begin
                        done <= 1'b1;
                        out_byte <= shift_reg;
                    end
                end

                RECOVER: begin
                    // Hold bit_cnt and shift_reg stable
                    bit_cnt <= 3'd0;
                    shift_reg <= shift_reg;
                end

                default: begin
                    bit_cnt <= 3'd0;
                    shift_reg <= 8'd0;
                end
            endcase
        end
    end

    // Next state combinational logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = RECEIVE;
            end

            RECEIVE: begin
                if (bit_cnt == 3'd7)
                    next_state = CHECK_STOP;
            end

            CHECK_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = RECOVER;
            end

            RECOVER: begin
                if (in == 1'b1)
                    next_state = IDLE;
            end
        endcase
    end

endmodule