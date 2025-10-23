module TopModule (
    input        clk,
    input        reset,    // synchronous active high
    input        data,
    output reg [3:0] count,
    output reg   counting,
    output reg   done,
    input        ack
);

    // FSM states
    localparam PATTERN_DETECT = 2'd0;
    localparam LOAD_DELAY     = 2'd1;
    localparam COUNTING       = 2'd2;
    localparam DONE_STATE     = 2'd3;

    reg [1:0] state;

    // Pattern detector shift register (4 bits)
    reg [3:0] pattern_shift;

    // Delay bits loading
    reg [2:0] delay_bit_count; // counts 0 to 3 bits shifted
    reg [3:0] delay_value;

    // Counting
    localparam integer CYCLES_PER_BLOCK = 1000;
    reg [3:0] block_count;    // from delay_value+1 down to 0
    reg [9:0] cycle_count;    // counts from 999 down to 0

    wire pattern_matched = (pattern_shift == 4'b1101);

    always @(posedge clk) begin
        if (reset) begin
            state <= PATTERN_DETECT;
            pattern_shift <= 4'b0000;
            delay_bit_count <= 3'd0;
            delay_value <= 4'd0;
            block_count <= 4'd0;
            cycle_count <= 10'd0;
            count <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            case (state)
                PATTERN_DETECT: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;

                    // Shift in data bit to detect pattern 1101
                    pattern_shift <= {pattern_shift[2:0], data};

                    // Clear delay loading and counters
                    delay_bit_count <= 3'd0;
                    delay_value <= 4'd0;
                    block_count <= 4'd0;
                    cycle_count <= 10'd0;

                    // Transition when pattern matched
                    if (pattern_matched) begin
                        state <= LOAD_DELAY;
                    end else begin
                        state <= PATTERN_DETECT;
                    end
                end

                LOAD_DELAY: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;

                    // Shift in 4 delay bits MSB first
                    delay_bit_count <= delay_bit_count + 1'b1;
                    delay_value <= {delay_value[2:0], data};

                    // Keep pattern_shift stable (no shifting)

                    // After 4 bits shifted in, start counting
                    if (delay_bit_count == 3'd3) begin
                        // Initialize counting counters
                        block_count <= {delay_value[2:0], data} + 1'b1; // (delay + 1)
                        cycle_count <= CYCLES_PER_BLOCK - 1;
                        state <= COUNTING;
                    end else begin
                        state <= LOAD_DELAY;
                    end
                end

                COUNTING: begin
                    counting <= 1'b1;
                    done <= 1'b0;
                    count <= block_count - 1; // Remaining delay block counting down from delay to 0

                    // Counting cycles down
                    if (cycle_count == 0) begin
                        if (block_count == 0) begin
                            // Counting finished
                            counting <= 1'b0;
                            done <= 1'b1;
                            count <= 4'd0;
                            state <= DONE_STATE;
                        end else begin
                            // Move to next block
                            block_count <= block_count - 1'b1;
                            cycle_count <= CYCLES_PER_BLOCK - 1;
                        end
                    end else begin
                        // Continue counting cycles
                        cycle_count <= cycle_count - 1'b1;
                    end

                    // Pattern shift and delay_bit_count stable
                    pattern_shift <= pattern_shift;
                    delay_bit_count <= delay_bit_count;
                    delay_value <= delay_value;
                end

                DONE_STATE: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'd0;

                    // Hold registers stable waiting for ack
                    pattern_shift <= pattern_shift;
                    delay_bit_count <= delay_bit_count;
                    delay_value <= delay_value;
                    block_count <= block_count;
                    cycle_count <= cycle_count;

                    if (ack) begin
                        // Restart pattern detection
                        state <= PATTERN_DETECT;
                        pattern_shift <= 4'b0000;
                        delay_bit_count <= 3'd0;
                        delay_value <= 4'd0;
                        block_count <= 4'd0;
                        cycle_count <= 10'd0;
                    end else begin
                        state <= DONE_STATE;
                    end
                end

                default: begin
                    state <= PATTERN_DETECT;
                    pattern_shift <= 4'b0000;
                    delay_bit_count <= 3'd0;
                    delay_value <= 4'd0;
                    block_count <= 4'd0;
                    cycle_count <= 10'd0;
                    count <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end
            endcase
        end
    end

endmodule