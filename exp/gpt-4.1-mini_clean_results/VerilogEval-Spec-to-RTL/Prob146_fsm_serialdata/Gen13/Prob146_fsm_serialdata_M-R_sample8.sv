module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output wire       done
);

    // Binary encoded states
    localparam IDLE       = 2'd0;
    localparam RECEIVE    = 2'd1;
    localparam STOP       = 2'd2;
    localparam ERROR_WAIT = 2'd3;

    reg [1:0] state, next_state;
    reg [2:0] bit_cnt;
    reg [7:0] data_reg;

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                if (bit_cnt == 3'd7)
                    next_state = STOP;
                else
                    next_state = RECEIVE;
            end

            STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = ERROR_WAIT;
            end

            ERROR_WAIT: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = ERROR_WAIT;
            end

            default: next_state = IDLE;
        endcase
    end

    // State, bit counter, and data register update
    always @(posedge clk) begin
        if (reset) begin
            state    <= IDLE;
            bit_cnt  <= 3'd0;
            data_reg <= 8'd0;
            out_byte <= 8'd0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    bit_cnt  <= 3'd0;
                    data_reg <= 8'd0;
                end

                RECEIVE: begin
                    bit_cnt <= bit_cnt + 3'd1;
                    // Shift in LSB first: new bit goes to MSB-7 shifting right
                    // But since protocol sends LSB first, we shift right and insert at MSB, 
                    // then later we can read LSB first
                    // Actually, to have LSB first in data_reg[0], shift right and insert at MSB
                    data_reg <= {in, data_reg[7:1]};
                end

                STOP: begin
                    // If valid stop bit, latch data to output
                    if (in == 1'b1)
                        out_byte <= data_reg;
                    // else no data update on error stop bit
                end

                ERROR_WAIT: begin
                    // Hold data and bit_cnt unchanged here
                end

                default: ;
            endcase
        end
    end

    // done is combinational: high only one cycle when in STOP state and in==1
    assign done = (state == STOP) && (in == 1'b1);

endmodule