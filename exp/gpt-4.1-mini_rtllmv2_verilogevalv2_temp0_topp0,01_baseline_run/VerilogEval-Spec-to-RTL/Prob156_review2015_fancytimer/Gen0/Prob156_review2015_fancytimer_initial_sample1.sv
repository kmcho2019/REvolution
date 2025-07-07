module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    // FSM states
    localparam SEARCH     = 3'd0;
    localparam LOAD_DELAY = 3'd1;
    localparam COUNT      = 3'd2;
    localparam DONE       = 3'd3;

    reg [2:0] state, next_state;

    // Shift register for pattern detection (4 bits)
    reg [3:0] pattern_shift;

    // Delay register (4 bits)
    reg [3:0] delay;

    // Bit counter for loading delay bits (0 to 3)
    reg [2:0] load_bit_count;

    // 10-bit cycle counter for counting 1000 cycles
    reg [9:0] cycle_count;

    // Remaining delay counter for counting down delay units
    reg [3:0] delay_remaining;

    // Pattern to detect: 1101 (binary)
    localparam [3:0] PATTERN = 4'b1101;

    // Synchronous FSM and registers
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'b0000;
            delay <= 4'b0000;
            load_bit_count <= 3'd0;
            cycle_count <= 10'd0;
            delay_remaining <= 4'd0;
            count <= 4'bxxxx; // don't care
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                SEARCH: begin
                    // Shift in data bit to pattern_shift
                    pattern_shift <= {pattern_shift[2:0], data};
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'bxxxx; // don't care
                end

                LOAD_DELAY: begin
                    // Shift in delay bits MSB first
                    // load_bit_count counts from 0 to 3
                    delay <= {delay[2:0], data};
                    load_bit_count <= load_bit_count + 1'b1;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'bxxxx; // don't care
                end

                COUNT: begin
                    counting <= 1'b1;
                    done <= 1'b0;
                    count <= delay_remaining;

                    if (cycle_count == 10'd999) begin
                        cycle_count <= 10'd0;
                        if (delay_remaining != 4'd0)
                            delay_remaining <= delay_remaining - 1'b1;
                    end else begin
                        cycle_count <= cycle_count + 1'b1;
                    end
                end

                DONE: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'bxxxx; // don't care
                end

                default: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'bxxxx; // don't care
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            SEARCH: begin
                // Check if pattern detected
                if (pattern_shift == PATTERN)
                    next_state = LOAD_DELAY;
            end

            LOAD_DELAY: begin
                if (load_bit_count == 3'd4)
                    next_state = COUNT;
            end

            COUNT: begin
                // When delay_remaining == 0 and cycle_count == 999, counting done
                if ((delay_remaining == 4'd0) && (cycle_count == 10'd999))
                    next_state = DONE;
            end

            DONE: begin
                if (ack)
                    next_state = SEARCH;
            end

            default: next_state = SEARCH;
        endcase
    end

    // Initialize load_bit_count and delay_remaining at state transitions
    always @(posedge clk) begin
        if (reset) begin
            load_bit_count <= 3'd0;
            delay_remaining <= 4'd0;
            cycle_count <= 10'd0;
        end else begin
            case (state)
                SEARCH: begin
                    load_bit_count <= 3'd0;
                    delay_remaining <= 4'd0;
                    cycle_count <= 10'd0;
                end

                LOAD_DELAY: begin
                    if (load_bit_count == 3'd4) begin
                        delay_remaining <= delay;
                        cycle_count <= 10'd0;
                    end
                end

                COUNT: begin
                    // cycle_count and delay_remaining updated in main always block
                end

                DONE: begin
                    // no change
                end
            endcase
        end
    end

endmodule