module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // One-hot state encoding
    localparam [3:0]
        IDLE      = 4'b0001,
        RECEIVE   = 4'b0010,
        CHECK_STOP= 4'b0100,
        WAIT_STOP = 4'b1000;

    reg [3:0] state, next_state;
    reg [2:0] bit_cnt;
    reg [7:0] shift_reg;

    // Next state and outputs combinational logic
    always @(*) begin
        next_state = state;
        done = 1'b0;
        case(state)
            IDLE: begin
                if (in == 1'b0)       // start bit detected
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
                if (in == 1'b1) begin
                    done = 1'b1;
                    next_state = IDLE;
                end else
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

    // Sequential logic: state and registers update
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_cnt <= 3'd0;
            shift_reg <= 8'd0;
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    bit_cnt <= 3'd0;
                    shift_reg <= 8'd0;
                end

                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]}; // LSB first means shift right with new MSB= in; alternative is shift left by 1 with MSB = in if carefully handled
                    bit_cnt <= bit_cnt + 1;
                end

                CHECK_STOP: begin
                    if (in == 1'b1) begin
                        out_byte <= shift_reg;
                        // done asserted combinationally in always @(*)
                    end
                end

                WAIT_STOP: begin
                    // no updates to shift_reg or bit_cnt, waiting for line to become idle
                end

                default: begin
                    bit_cnt <= 3'd0;
                    shift_reg <= 8'd0;
                end
            endcase
        end
    end
endmodule