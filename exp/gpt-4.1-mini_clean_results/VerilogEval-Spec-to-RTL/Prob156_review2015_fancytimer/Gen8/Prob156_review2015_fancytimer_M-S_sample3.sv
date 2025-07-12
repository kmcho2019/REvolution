module TopModule (
    input  clk,
    input  reset,  // synchronous active-high reset
    input  data,
    output reg [3:0] count,
    output reg       counting,
    output reg       done,
    input  ack
);

    // States
    localparam SEARCH   = 2'd0;
    localparam LOAD     = 2'd1;
    localparam COUNT    = 2'd2;
    localparam WAIT_ACK = 2'd3;

    reg [1:0] state;

    // Pattern detection shift register (4 bits)
    reg [3:0] pattern_shift;

    // Delay bits register (4 bits)
    reg [3:0] delay_reg;
    reg [2:0] load_count;  // counts bits loaded, 0..3

    // Counters for timing
    reg [11:0] cycle_counter;  // counts 0..999
    reg [4:0]  tick_counter;   // counts delay+1 down to 0

    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'b0;
            delay_reg <= 4'b0;
            load_count <= 3'd0;
            cycle_counter <= 12'd0;
            tick_counter <= 5'd0;
            count <= 4'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            case(state)
                SEARCH: begin
                    // Shift in data for pattern detection
                    pattern_shift <= {pattern_shift[2:0], data};
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0;

                    if (pattern_shift == 4'b1101) begin
                        // Detected pattern, start loading delay bits
                        state <= LOAD;
                        load_count <= 3'd0;
                        delay_reg <= 4'b0;
                    end
                end

                LOAD: begin
                    // Shift in MSB first: shift left and add new bit at LSB
                    delay_reg <= {delay_reg[2:0], data};
                    load_count <= load_count + 1'b1;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0;

                    if (load_count == 3'd3) begin
                        // After 4 bits loaded (0 to 3)
                        tick_counter <= delay_reg + 1'b1; // (delay+1)
                        cycle_counter <= 12'd0;
                        state <= COUNT;
                    end
                end

                COUNT: begin
                    counting <= 1'b1;
                    done <= 1'b0;

                    // Output count is tick_counter - 1 while counting
                    if (tick_counter != 0)
                        count <= tick_counter - 1'b1;
                    else
                        count <= 4'b0;

                    if (cycle_counter == 12'd999) begin
                        cycle_counter <= 12'd0;
                        if (tick_counter != 0) begin
                            tick_counter <= tick_counter - 1'b1;
                            if (tick_counter == 1) begin
                                // Finished last 1000 cycle chunk, done counting
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
                    pattern_shift <= 4'b0; // clear to prevent false detection

                    if (ack) begin
                        // Reset to search pattern after ack
                        state <= SEARCH;
                        delay_reg <= 4'b0;
                        load_count <= 3'd0;
                        cycle_counter <= 12'd0;
                        tick_counter <= 5'd0;
                        done <= 1'b0;
                    end
                end

                default: begin
                    // Failsafe reset
                    state <= SEARCH;
                    pattern_shift <= 4'b0;
                    delay_reg <= 4'b0;
                    load_count <= 3'd0;
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