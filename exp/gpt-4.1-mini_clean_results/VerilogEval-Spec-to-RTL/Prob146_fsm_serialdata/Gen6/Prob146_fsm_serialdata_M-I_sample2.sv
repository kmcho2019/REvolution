module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // State encoding (binary)
    localparam IDLE       = 2'd0;
    localparam RECEIVE    = 2'd1;
    localparam CHECK_STOP = 2'd2;
    localparam WAIT_STOP  = 2'd3;

    reg [1:0] state, next_state;
    reg [2:0] bit_cnt;
    reg [7:0] shift_reg;

    // Combinational next-state logic
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
                    next_state = CHECK_STOP;
                else
                    next_state = RECEIVE;
            end

            CHECK_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end

            WAIT_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end

            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: state update, counters, shift register, outputs
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_cnt <= 3'd0;
            shift_reg <= 8'd0;
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            done <= 1'b0; // Default done low unless set below

            case (state)
                IDLE: begin
                    bit_cnt <= 3'd0;
                    shift_reg <= 8'd0;
                end

                RECEIVE: begin
                    // Shift in LSB first
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_cnt <= bit_cnt + 1;
                end

                CHECK_STOP: begin
                    if (in == 1'b1) begin
                        out_byte <= shift_reg;
                        done <= 1'b1; // Assert done for one cycle
                    end
                end

                WAIT_STOP: begin
                    // No changes except waiting for stop bit (in=1)
                end

                default: ;
            endcase
        end
    end

endmodule