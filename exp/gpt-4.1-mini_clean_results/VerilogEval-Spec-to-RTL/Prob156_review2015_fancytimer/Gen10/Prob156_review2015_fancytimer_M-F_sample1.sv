module TopModule (
    input  clk,
    input  reset,  // synchronous active-high reset
    input  data,
    output reg [3:0] count,
    output reg       counting,
    output reg       done,
    input  ack
);

    // State encoding (one-hot)
    localparam SEARCH    = 4'b0001;
    localparam LOAD      = 4'b0010;
    localparam COUNT     = 4'b0100;
    localparam WAIT_ACK  = 4'b1000;

    reg [3:0] state;

    // Pattern detection shift register (4 bits)
    reg [3:0] pattern_shift;

    // Delay register (hold bits loaded in LOAD)
    reg [3:0] delay_reg;
    reg [1:0] load_bit_count;  // counts from 0 to 3

    // Cycle counters
    reg [11:0] cycle_counter;  // counts clock cycles 0..999
    reg [3:0] tick_counter;    // counts 1000-cycle blocks remaining

    always @(posedge clk) begin
        if (reset) begin
            // Reset all registers and outputs
            state          <= SEARCH;
            pattern_shift  <= 4'b0;
            delay_reg      <= 4'b0;
            load_bit_count <= 2'd0;
            cycle_counter  <= 12'd0;
            tick_counter   <= 4'd0;
            count          <= 4'd0;
            counting       <= 1'b0;
            done           <= 1'b0;
        end else begin
            case(state)

                SEARCH: begin
                    // Shift in data to detect pattern 1101
                    pattern_shift <= {pattern_shift[2:0], data};

                    // Outputs inactive during SEARCH
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0; // don't-care replaced with zero for synth

                    if (pattern_shift == 4'b1101) begin
                        state <= LOAD;
                        delay_reg <= 4'b0;
                        load_bit_count <= 2'd0;
                    end
                end

                LOAD: begin
                    // Shift delay_reg left and insert new bit at LSB (MSB first)
                    delay_reg <= {delay_reg[2:0], data};
                    load_bit_count <= load_bit_count + 1'b1;

                    // Outputs inactive during LOAD
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0; // don't-care replaced with zero

                    if (load_bit_count == 2'd3) begin
                        // After loading 4 bits (this cycle), initialize counters
                        tick_counter <= {delay_reg[2:0], data} + 4'd1; // full delay + 1
                        cycle_counter <= 12'd0;
                        state <= COUNT;
                    end
                end

                COUNT: begin
                    counting <= 1'b1;
                    done <= 1'b0;

                    // Output count = tick_counter - 1 if tick_counter>0 else 0
                    if (tick_counter != 0)
                        count <= tick_counter - 1'b1;
                    else
                        count <= 4'd0;

                    // Increment cycle_counter each clock
                    if (cycle_counter == 12'd999) begin
                        cycle_counter <= 12'd0;
                        if (tick_counter != 0) begin
                            tick_counter <= tick_counter - 1'b1;
                            if (tick_counter == 1) begin
                                // Finished all ticks
                                counting <= 1'b0;
                                done <= 1'b1;
                                count <= 4'd0; // valid don't-care replaced by zero
                                state <= WAIT_ACK;
                            end
                        end
                    end else begin
                        cycle_counter <= cycle_counter + 1'b1;
                    end
                end

                WAIT_ACK: begin
                    // Wait for user to acknowledge done
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'd0; // don't-care replaced with zero

                    // Clear pattern_shift to prevent false detection before restart
                    pattern_shift <= 4'b0;

                    if (ack) begin
                        // Return to searching for next sequence
                        state <= SEARCH;
                        delay_reg <= 4'b0;
                        load_bit_count <= 2'd0;
                        cycle_counter <= 12'd0;
                        tick_counter <= 4'd0;
                        done <= 1'b0;
                        counting <= 1'b0;
                        count <= 4'd0;
                    end
                end

                default: begin
                    // Safety fallback to SEARCH
                    state          <= SEARCH;
                    pattern_shift  <= 4'b0;
                    delay_reg      <= 4'b0;
                    load_bit_count <= 2'd0;
                    cycle_counter  <= 12'd0;
                    tick_counter   <= 4'd0;
                    count          <= 4'd0;
                    counting       <= 1'b0;
                    done           <= 1'b0;
                end

            endcase
        end
    end

endmodule