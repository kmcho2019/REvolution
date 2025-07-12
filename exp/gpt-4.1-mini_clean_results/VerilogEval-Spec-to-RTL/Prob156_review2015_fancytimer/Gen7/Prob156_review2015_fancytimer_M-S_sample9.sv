module TopModule (
    input        clk,
    input        reset,  // synchronous active-high reset
    input        data,
    output reg [3:0] count,
    output reg       counting,
    output reg       done,
    input        ack
);

    // States
    localparam SEARCH   = 2'd0;
    localparam LOAD     = 2'd1;
    localparam COUNT    = 2'd2;
    localparam WAIT_ACK = 2'd3;

    reg [1:0] state;

    // Shift register for pattern detection
    reg [3:0] pattern_shift;

    // Delay register for loaded bits
    reg [3:0] delay_reg;

    // Bit counter for loading delay bits (0 to 3)
    reg [2:0] load_bit_count;

    // Counters for counting cycles
    reg [11:0] cycle_counter; // counts 0..999
    reg [4:0] tick_counter;   // counts delay+1 down to 0

    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'b0;
            delay_reg <= 4'b0;
            load_bit_count <= 3'd0;
            cycle_counter <= 12'd0;
            tick_counter <= 5'd0;
            count <= 4'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            case(state)
                SEARCH: begin
                    // Shift in new bit for pattern detection
                    pattern_shift <= {pattern_shift[2:0], data};

                    // Outputs while searching
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0;

                    // If pattern 1101 detected, move to LOAD next cycle
                    if (pattern_shift == 4'b1101) begin
                        state <= LOAD;
                        delay_reg <= 4'b0;
                        load_bit_count <= 3'd0;
                    end
                end

                LOAD: begin
                    // Shift in delay bits MSB first
                    delay_reg <= {delay_reg[2:0], data};
                    load_bit_count <= load_bit_count + 1'b1;

                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0;

                    // After loading 4 bits, start counting
                    if (load_bit_count == 3'd3) begin
                        tick_counter <= delay_reg + 1'b1; // delay+1
                        cycle_counter <= 12'd0;
                        state <= COUNT;
                    end
                end

                COUNT: begin
                    counting <= 1'b1;
                    done <= 1'b0;
                    // count output is current tick_counter - 1 (delay down to 0)
                    // tick_counter > 0 here
                    count <= tick_counter - 1;

                    if (cycle_counter == 12'd999) begin
                        cycle_counter <= 12'd0;
                        if (tick_counter != 0) begin
                            tick_counter <= tick_counter - 1'b1;
                            // If tick_counter decremented to 0, counting done next cycle
                            if (tick_counter == 1) begin
                                counting <= 1'b0;
                                done <= 1'b1;
                                count <= 4'b0;
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
                    count <= 4'b0;

                    // Stay here until ack is high
                    if (ack) begin
                        state <= SEARCH;
                        pattern_shift <= 4'b0;
                        delay_reg <= 4'b0;
                        load_bit_count <= 3'd0;
                        cycle_counter <= 12'd0;
                        tick_counter <= 5'd0;
                        done <= 1'b0;
                    end
                end

                default: begin
                    // Safe fallback
                    state <= SEARCH;
                    pattern_shift <= 4'b0;
                    delay_reg <= 4'b0;
                    load_bit_count <= 3'd0;
                    cycle_counter <= 12'd0;
                    tick_counter <= 5'd0;
                    count <= 4'b0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end
            endcase
        end
    end

endmodule