module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    typedef enum logic [1:0] {
        IDLE = 2'd0,
        START = 2'd1,
        RECEIVE = 2'd2,
        STOP = 2'd3
    } state_t;

    state_t state, next_state;

    reg [2:0] bit_count; // to count 8 bits received
    reg [7:0] shift_reg;

    // Sequential logic for state transition and registers
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0; // default done low unless set below

            case (state)
                IDLE: begin
                    // waiting for start bit (in==0)
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end
                START: begin
                    // Just confirmed start bit, wait to receive data bits
                    bit_count <= 3'd0;
                end
                RECEIVE: begin
                    // shift in bit LSB first
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count + 3'd1;
                end
                STOP: begin
                    // Check stop bit
                    if (in == 1'b1) begin
                        // Valid stop bit, output the byte and done
                        out_byte <= shift_reg;
                        done <= 1'b1;
                        // after done, wait for next start
                    end
                end
            endcase
        end
    end

    // Next state logic combinational
    always @(*) begin
        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = START; // start bit detected
                else
                    next_state = IDLE;
            end
            START: begin
                if (in == 1'b0)
                    next_state = RECEIVE; // confirmed start bit stable
                else
                    next_state = IDLE; // false start, go back
            end
            RECEIVE: begin
                if (bit_count == 3'd7)
                    next_state = STOP; // after 8 bits received (0..7)
                else
                    next_state = RECEIVE;
            end
            STOP: begin
                if (in == 1'b1)
                    next_state = IDLE; // stop bit correct, go idle
                else
                    next_state = STOP; // wait for stop bit
            end
            default: next_state = IDLE;
        endcase
    end

endmodule