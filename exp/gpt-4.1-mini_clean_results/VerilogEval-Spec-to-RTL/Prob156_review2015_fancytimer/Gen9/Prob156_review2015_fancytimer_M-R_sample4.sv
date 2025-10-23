module TopModule (
    input  clk,
    input  reset,  // synchronous active-high reset
    input  data,
    output reg [3:0] count,
    output reg       counting,
    output reg       done,
    input  ack
);

    // One-hot states for clarity
    localparam SEARCH    = 4'b0001;
    localparam LOAD      = 4'b0010;
    localparam COUNT     = 4'b0100;
    localparam WAIT_ACK  = 4'b1000;

    reg [3:0] state;

    // Pattern detection shift register (4 bits)
    reg [3:0] pattern_shift;

    // Delay bits register and load counter
    reg [3:0] delay_reg;
    reg [2:0] load_bit_count;  // 0..3 bits loaded

    // Timing counters
    reg [11:0] cycle_counter;  // counts 0..999 cycles
    reg [3:0] tick_counter;    // counts remaining ticks (delay+1) down to 0

    always @(posedge clk) begin
        if (reset) begin
            state          <= SEARCH;
            pattern_shift  <= 4'b0;
            delay_reg      <= 4'b0;
            load_bit_count <= 3'd0;
            cycle_counter  <= 12'd0;
            tick_counter   <= 4'd0;
            count          <= 4'b0;
            counting       <= 1'b0;
            done           <= 1'b0;
        end else begin
            case(state)

                SEARCH: begin
                    // Shift in data for pattern detection
                    pattern_shift <= {pattern_shift[2:0], data};

                    // Outputs inactive during search
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'bx; // don't-care per spec

                    // Pattern detected when shift register equals 1101
                    // This compares after shift on this clock, so detection aligned correctly
                    if (pattern_shift == 4'b1101) begin
                        state <= LOAD;
                        delay_reg <= 4'b0;
                        load_bit_count <= 3'd0;
                    end
                end

                LOAD: begin
                    // Shift in MSB first: shift left and insert new bit at LSB
                    delay_reg <= {delay_reg[2:0], data};
                    load_bit_count <= load_bit_count + 1'b1;

                    // Outputs inactive while loading delay
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'bx; // don't-care

                    if (load_bit_count == 3'd3) begin
                        // Completed loading 4 bits this cycle
                        // Initialize counters at next cycle
                        tick_counter <= {delay_reg[2:0], data} + 4'd1; // full 4-bit delay + 1
                        cycle_counter <= 12'd0;
                        state <= COUNT;
                    end
                end

                COUNT: begin
                    counting <= 1'b1;
                    done <= 1'b0;

                    // Output count = tick_counter - 1 stable for 1000 cycles
                    // When tick_counter == 0, count = 0
                    if (tick_counter != 0)
                        count <= tick_counter - 1'b1;
                    else
                        count <= 4'b0;

                    if (cycle_counter == 12'd999) begin
                        cycle_counter <= 12'd0;
                        if (tick_counter != 0) begin
                            tick_counter <= tick_counter - 1'b1;
                            if (tick_counter == 1) begin
                                // Finished counting all ticks
                                counting <= 1'b0;
                                done <= 1'b1;
                                count <= 4'bx; // don't-care after done
                                state <= WAIT_ACK;
                            end
                        end
                    end else begin
                        cycle_counter <= cycle_counter + 1'b1;
                    end
                end

                WAIT_ACK: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'bx; // don't-care

                    // Clear pattern_shift to prevent false detection before returning to SEARCH
                    pattern_shift <= 4'b0;

                    if (ack) begin
                        // After ack, return to searching
                        state <= SEARCH;
                        delay_reg <= 4'b0;
                        load_bit_count <= 3'd0;
                        cycle_counter <= 12'd0;
                        tick_counter <= 4'd0;
                        done <= 1'b0;
                        counting <= 1'b0;
                        count <= 4'bx;
                    end
                end

                default: begin
                    // Safe reset state
                    state          <= SEARCH;
                    pattern_shift  <= 4'b0;
                    delay_reg      <= 4'b0;
                    load_bit_count <= 3'd0;
                    cycle_counter  <= 12'd0;
                    tick_counter   <= 4'd0;
                    count          <= 4'b0;
                    counting       <= 1'b0;
                    done           <= 1'b0;
                end

            endcase
        end
    end

endmodule