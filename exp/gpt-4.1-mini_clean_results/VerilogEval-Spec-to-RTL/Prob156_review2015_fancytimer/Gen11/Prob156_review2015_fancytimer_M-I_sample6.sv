module TopModule(
    input        clk,
    input        reset,    // synchronous active high
    input        data,
    output reg [3:0] count,
    output reg   counting,
    output reg   done,
    input        ack
);

    // States encoding
    localparam SEARCH     = 2'd0;
    localparam LOAD_DELAY = 2'd1;
    localparam COUNTING   = 2'd2;
    localparam DONE_WAIT  = 2'd3;

    reg [1:0] state;

    reg [3:0] pattern_shift; // for detecting 1101 start pattern

    reg [2:0] load_count;    // counts bits loaded in LOAD_DELAY: 0 to 3
    reg [3:0] delay_reg;     // stores delay bits loaded in LOAD_DELAY

    reg [9:0] cycle_count;   // counts cycles 0 to 999
    reg [3:0] block_count;   // counts blocks remaining, delay down to 0

    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'd0;
            load_count <= 3'd0;
            delay_reg <= 4'd0;
            cycle_count <= 10'd0;
            block_count <= 4'd0;
            count <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            case(state)
                SEARCH: begin
                    // Shift in new data bit and then check pattern immediately
                    pattern_shift <= {pattern_shift[2:0], data};

                    // Remain in SEARCH until pattern detected
                    if ({pattern_shift[2:0], data} == 4'b1101) begin
                        state <= LOAD_DELAY;
                        load_count <= 3'd0;
                        delay_reg <= 4'd0;
                    end

                    // Outputs inactive
                    count <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end

                LOAD_DELAY: begin
                    // Shift in delay bit MSB first
                    delay_reg <= {delay_reg[2:0], data};
                    load_count <= load_count + 1'b1;

                    // Stay in LOAD_DELAY until 4 bits loaded
                    if (load_count == 3'd3) begin
                        // All 4 bits shifted in, start counting
                        state <= COUNTING;
                        cycle_count <= 10'd0;
                        block_count <= delay_reg + 1'b1; // blocks = delay + 1
                    end

                    // Outputs inactive
                    count <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end

                COUNTING: begin
                    counting <= 1'b1;
                    done <= 1'b0;

                    if (cycle_count == 10'd999) begin
                        cycle_count <= 10'd0;
                        if (block_count != 4'd0)
                            block_count <= block_count - 1'b1;
                    end else begin
                        cycle_count <= cycle_count + 1'b1;
                    end

                    // Output remaining time in blocks (counting down)
                    count <= block_count;

                    // When counting complete (block_count=0 and cycle_count=999), go to DONE_WAIT
                    if ((block_count == 4'd0) && (cycle_count == 10'd999)) begin
                        state <= DONE_WAIT;
                        counting <= 1'b0;
                        done <= 1'b1;
                        count <= 4'd0;
                    end
                end

                DONE_WAIT: begin
                    // Assert done, wait for ack
                    done <= 1'b1;
                    counting <= 1'b0;
                    count <= 4'd0;

                    if (ack) begin
                        state <= SEARCH;
                        pattern_shift <= 4'd0;
                        load_count <= 3'd0;
                        delay_reg <= 4'd0;
                        cycle_count <= 10'd0;
                        block_count <= 4'd0;
                        count <= 4'd0;
                        counting <= 1'b0;
                        done <= 1'b0;
                    end
                end

                default: begin
                    // Safe default to SEARCH and clear all registers
                    state <= SEARCH;
                    pattern_shift <= 4'd0;
                    load_count <= 3'd0;
                    delay_reg <= 4'd0;
                    cycle_count <= 10'd0;
                    block_count <= 4'd0;
                    count <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end
            endcase
        end
    end

endmodule