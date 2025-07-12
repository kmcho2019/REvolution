module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    // States
    localparam SEARCH = 2'd0;
    localparam READ_DELAY = 2'd1;
    localparam COUNT = 2'd2;
    localparam DONE = 2'd3;

    reg [1:0] state, next_state;

    // Pattern detection shift register (4 bits)
    reg [3:0] pattern_shift;

    // Delay register and bit counter for reading delay bits
    reg [3:0] delay;
    reg [2:0] delay_bits_read; // counts 0 to 3

    // Counters for COUNT state
    reg [9:0] cycle_count;  // counts 0 to 999
    reg [3:0] remaining;    // delay countdown

    // FSM synchronous logic
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'd0;
            delay <= 4'd0;
            delay_bits_read <= 3'd0;
            cycle_count <= 10'd0;
            remaining <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'd0;
        end else begin
            state <= next_state;

            case (state)
                SEARCH: begin
                    // Shift in data bit, MSB at left
                    pattern_shift <= {pattern_shift[2:0], data};
                    delay_bits_read <= 3'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    cycle_count <= 10'd0;
                    remaining <= 4'd0;
                    count <= 4'd0;
                    delay <= 4'd0;
                end

                READ_DELAY: begin
                    // Shift in data MSB first: shift left and insert data at LSB
                    delay <= {delay[2:0], data};
                    delay_bits_read <= delay_bits_read + 1'b1;
                    counting <= 1'b0;
                    done <= 1'b0;
                    cycle_count <= 10'd0;
                    remaining <= 4'd0;
                    count <= 4'd0;
                end

                COUNT: begin
                    counting <= 1'b1;
                    done <= 1'b0;
                    count <= remaining;

                    if (cycle_count == 10'd999) begin
                        cycle_count <= 10'd0;
                        if (remaining != 4'd0) begin
                            remaining <= remaining - 1'b1;
                        end else begin
                            // finished counting last block, keep remaining=0
                            remaining <= 4'd0;
                        end
                    end else begin
                        cycle_count <= cycle_count + 1'b1;
                    end
                end

                DONE: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'd0;
                    cycle_count <= 10'd0;
                    remaining <= 4'd0;
                    // pattern_shift and delay_bits_read keep their values until SEARCH resets
                end

                default: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end
            endcase
        end
    end

    // Combinational next state logic
    always @(*) begin
        next_state = state;
        case (state)
            SEARCH: begin
                if (pattern_shift == 4'b1101)
                    next_state = READ_DELAY;
            end

            READ_DELAY: begin
                if (delay_bits_read == 3'd3)
                    next_state = COUNT;
            end

            COUNT: begin
                // After counting (delay+1)*1000 cycles:
                // remaining counts down from delay to 0, each lasting 1000 cycles
                // Transition when remaining==0 and cycle_count==999 (last cycle of last block)
                if (remaining == 4'd0 && cycle_count == 10'd999)
                    next_state = DONE;
            end

            DONE: begin
                if (ack)
                    next_state = SEARCH;
            end

            default: next_state = SEARCH;
        endcase
    end

    // Initialize remaining and cycle_count on entering COUNT state
    // To capture delay+1*1000 cycles, remaining should be delay initially,
    // since counting down from delay to 0 covers delay+1 blocks.

    // To synchronize loading, use a register to detect state transitions
    reg [1:0] state_d;

    always @(posedge clk) begin
        if (reset)
            state_d <= SEARCH;
        else
            state_d <= state;
    end

    always @(posedge clk) begin
        // On transition into COUNT, initialize remaining and cycle_count
        if (state == COUNT && state_d != COUNT) begin
            remaining <= delay;
            cycle_count <= 10'd0;
        end
    end

endmodule