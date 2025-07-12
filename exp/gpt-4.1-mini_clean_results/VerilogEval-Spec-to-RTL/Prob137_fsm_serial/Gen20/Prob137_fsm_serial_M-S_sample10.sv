module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    typedef enum logic [1:0] {
        IDLE       = 2'd0,
        RECEIVE    = 2'd1,
        CHECK_STOP = 2'd2,
        ERROR_WAIT = 2'd3
    } state_t;

    state_t state, next_state;
    reg [2:0] bit_cnt;          // counts 0 to 7 for 8 data bits
    reg [7:0] data_reg;         // shift register for data bits LSB first

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (in == 1'b0) // start bit detected (line low)
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
                if (in == 1'b1) // valid stop bit
                    next_state = IDLE;
                else
                    next_state = ERROR_WAIT;
            end

            ERROR_WAIT: begin
                if (in == 1'b1) // wait until line idle again
                    next_state = IDLE;
                else
                    next_state = ERROR_WAIT;
            end
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_cnt <= 3'd0;
            data_reg <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0; // default done low

            case (state)
                IDLE: begin
                    bit_cnt <= 3'd0;
                    data_reg <= 8'd0;
                end

                RECEIVE: begin
                    // Shift in LSB first: new bit is LSB, shift older bits left
                    data_reg <= {in, data_reg[7:1]};
                    bit_cnt <= bit_cnt + 3'd1;
                end

                CHECK_STOP: begin
                    if (in == 1'b1)
                        done <= 1'b1; // valid stop bit signals done
                end

                ERROR_WAIT: begin
                    // wait for line idle; no state variables updated except state
                end
            endcase
        end
    end

endmodule