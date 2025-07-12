module TopModule (
    input clk,
    input reset,
    input in,
    output reg done
);

    // States encoding
    localparam IDLE      = 3'd0,
               START     = 3'd1,
               DATA      = 3'd2,
               STOP      = 3'd3,
               WAIT_STOP = 3'd4;

    reg [2:0] state, next_state;
    reg [3:0] bit_count;      // count 0 to 7 for data bits
    reg [7:0] data_shift;

    // Sequential logic for state and counters
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            data_shift <= 0;
            done <= 0;
        end else begin
            state <= next_state;
            // Default done low, only asserted one cycle in STOP with correct stop bit
            done <= 0;

            case(state)
                IDLE: begin
                    bit_count <= 0;
                    data_shift <= 0;
                end
                START: begin
                    bit_count <= 0;
                    data_shift <= 0;
                end
                DATA: begin
                    // Shift in data bits LSB first
                    data_shift <= {in, data_shift[7:1]};
                    bit_count <= bit_count + 1;
                end
                STOP: begin
                    // done asserted if stop bit correct
                    if (in == 1'b1)
                        done <= 1'b1;
                end
                WAIT_STOP: begin
                    // no bit_count increment or data_shift changes here
                end
            endcase
        end
    end

    // Combinational next state logic
    always @(*) begin
        next_state = state;
        case(state)
            IDLE: begin
                // wait for start bit (0)
                if (in == 1'b0)
                    next_state = START;
            end
            START: begin
                // In this design, START state is just one cycle to confirm start bit
                // Next go to DATA
                next_state = DATA;
            end
            DATA: begin
                if (bit_count == 4'd7)
                    next_state = STOP;
                else
                    next_state = DATA;
            end
            STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;      // correct stop bit, back to IDLE to receive next byte
                else
                    next_state = WAIT_STOP; // bad stop bit, wait until we get a stop bit
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

endmodule