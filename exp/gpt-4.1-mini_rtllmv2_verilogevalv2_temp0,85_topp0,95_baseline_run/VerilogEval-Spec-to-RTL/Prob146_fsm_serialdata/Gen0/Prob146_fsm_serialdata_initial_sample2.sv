module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        RECEIVE = 2'b01,
        STOP = 2'b10,
        WAIT_STOP = 2'b11
    } state_t;

    state_t state, next_state;

    reg [3:0] bit_count;   // count bits received (0 to 8)
    reg [7:0] shift_reg;   // shift register for received bits

    // State register and synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 4'd0;
            shift_reg <= 8'd0;
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0; // default done low each cycle unless set below

            case (state)
                IDLE: begin
                    // waiting for start bit (0)
                    bit_count <= 4'd0;
                    shift_reg <= 8'd0;
                    if (in == 1'b0) begin
                        // start bit detected, move to RECEIVE
                        bit_count <= 4'd0;
                    end
                end

                RECEIVE: begin
                    // shift in bits LSB first
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count + 1'b1;
                end

                STOP: begin
                    // check stop bit
                    if (in == 1'b1) begin
                        out_byte <= shift_reg;
                        done <= 1'b1;
                    end
                    // else done=0 by default, will go to WAIT_STOP if stop bit wrong
                end

                WAIT_STOP: begin
                    // wait until in==1 (stop bit) to return to IDLE
                    // done remains 0
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (in == 1'b0) begin
                    next_state = RECEIVE;
                end else begin
                    next_state = IDLE;
                end
            end

            RECEIVE: begin
                if (bit_count == 4'd7) begin
                    // just received last data bit, next clock will be stop bit
                    next_state = STOP;
                end else begin
                    next_state = RECEIVE;
                end
            end

            STOP: begin
                if (in == 1'b1) begin
                    // stop bit correct, next byte
                    next_state = IDLE;
                end else begin
                    // stop bit incorrect, wait for stop bit
                    next_state = WAIT_STOP;
                end
            end

            WAIT_STOP: begin
                if (in == 1'b1) begin
                    next_state = IDLE;
                end else begin
                    next_state = WAIT_STOP;
                end
            end

            default: next_state = IDLE;
        endcase
    end

endmodule