module TopModule (
    input        clk,
    input        reset,   // synchronous active high
    input        data,
    output reg [3:0] count,
    output reg   counting,
    output reg   done,
    input        ack
);

    // State encoding
    localparam SEARCH     = 2'd0;
    localparam LOAD_DELAY = 2'd1;
    localparam COUNTING   = 2'd2;
    localparam DONE       = 2'd3;

    reg [1:0] state;

    // Shift register to detect pattern 1101 in SEARCH state
    reg [3:0] pattern_shift;

    // Delay register (loaded from serial input bits)
    reg [3:0] delay_reg;

    // Counter for bits loaded in LOAD_DELAY (0 to 3)
    reg [2:0] load_bit_count;

    // Cycle counter for 1000 clock cycles per delay unit (0 to 999)
    reg [9:0] cycle_counter;

    // Delay units counter (counts down from delay_reg+1 to 0)
    reg [4:0] delay_counter; // 5 bits to hold delay+1 up to 17

    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'd0;
            delay_reg <= 4'd0;
            load_bit_count <= 3'd0;
            cycle_counter <= 10'd0;
            delay_counter <= 5'd0;

            count <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            case(state)
                SEARCH: begin
                    // Shift in data bit for pattern detection
                    pattern_shift <= {pattern_shift[2:0], data};
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;

                    // Check for pattern 1101
                    if (pattern_shift == 4'b1101) begin
                        state <= LOAD_DELAY;
                        delay_reg <= 4'd0;
                        load_bit_count <= 3'd0;
                    end
                end

                LOAD_DELAY: begin
                    // Shift in delay bits MSB first
                    delay_reg <= {delay_reg[2:0], data};
                    load_bit_count <= load_bit_count + 1;

                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;

                    if (load_bit_count == 3'd3) begin
                        // Loaded 4 bits; initialize delay_counter with delay_reg + 1
                        delay_counter <= {1'b0, delay_reg} + 1'b1;
                        cycle_counter <= 10'd0;
                        state <= COUNTING;
                    end
                end

                COUNTING: begin
                    counting <= 1'b1;
                    done <= 1'b0;
                    // Output current delay units remaining minus 1 (to show 0..delay)
                    // When delay_counter=0 means done counting
                    if (delay_counter != 0)
                        count <= delay_counter[3:0] - 1;
                    else
                        count <= 4'd0;

                    // Count 1000 cycles per delay unit
                    if (cycle_counter == 10'd999) begin
                        cycle_counter <= 10'd0;
                        if (delay_counter != 0)
                            delay_counter <= delay_counter - 1;
                    end else begin
                        cycle_counter <= cycle_counter + 1;
                    end

                    // Transition to DONE when delay_counter hits 0 and last 1000 cycles done
                    if ((delay_counter == 0) && (cycle_counter == 10'd999)) begin
                        state <= DONE;
                        counting <= 1'b0;
                        done <= 1'b1;
                        count <= 4'd0;
                    end
                end

                DONE: begin
                    done <= 1'b1;
                    counting <= 1'b0;
                    count <= 4'd0;

                    // Wait for ack to return to SEARCH
                    if (ack) begin
                        state <= SEARCH;
                        pattern_shift <= 4'd0;
                    end
                end

                default: begin
                    // Should never happen, reset state
                    state <= SEARCH;
                    pattern_shift <= 4'd0;
                    delay_reg <= 4'd0;
                    load_bit_count <= 3'd0;
                    cycle_counter <= 10'd0;
                    delay_counter <= 5'd0;

                    count <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end
            endcase
        end
    end

endmodule