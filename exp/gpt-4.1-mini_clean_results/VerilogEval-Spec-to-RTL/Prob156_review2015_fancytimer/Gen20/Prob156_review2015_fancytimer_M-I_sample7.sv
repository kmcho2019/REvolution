module TopModule (
    input        clk,
    input        reset,  // synchronous active high
    input        data,
    output reg [3:0] count,
    output reg   counting,
    output reg   done,
    input        ack
);

    // States
    localparam SEARCH = 2'd0;
    localparam LOAD   = 2'd1;
    localparam COUNT  = 2'd2;
    localparam DONE   = 2'd3;

    reg [1:0] state, next_state;
    reg [1:0] prev_state;

    // Shift register for pattern detection (4 bits)
    reg [3:0] pattern_shift;

    // Delay register (4 bits)
    reg [3:0] delay;

    // Counter for bits loaded in LOAD state (0..3)
    reg [2:0] load_cnt;

    // 10-bit cycle counter (0..999)
    reg [9:0] cycle_cnt;

    // 5-bit block counter (counts delay+1 down to 0)
    reg [4:0] block_cnt;

    // Next state logic combinational
    always @(*) begin
        next_state = state;
        case(state)
            SEARCH: if (pattern_shift == 4'b1101) next_state = LOAD;
            LOAD:   if (load_cnt == 3'd4) next_state = COUNT;
            COUNT:  if ((block_cnt == 0) && (cycle_cnt == 10'd999)) next_state = DONE;
            DONE:   if (ack) next_state = SEARCH;
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            prev_state <= SEARCH;
            pattern_shift <= 4'b0000;
            delay <= 4'b0000;
            load_cnt <= 3'd0;
            cycle_cnt <= 10'd0;
            block_cnt <= 5'd0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0000;
        end else begin
            prev_state <= state;
            state <= next_state;

            case(state)
                SEARCH: begin
                    // Shift in data for pattern detection
                    pattern_shift <= {pattern_shift[2:0], data};

                    // Reset load and counters
                    load_cnt <= 3'd0;
                    delay <= 4'b0000;
                    cycle_cnt <= 10'd0;
                    block_cnt <= 5'd0;

                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0000; // don't-care output
                end

                LOAD: begin
                    // Freeze pattern_shift
                    pattern_shift <= pattern_shift;

                    // Shift in delay bits MSB first into delay register
                    // delay[3] is first bit loaded, shift left and append new data at LSB
                    delay <= {delay[2:0], data};

                    load_cnt <= load_cnt + 1'b1;

                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0000; // don't-care output
                end

                COUNT: begin
                    // Freeze pattern_shift and load_cnt
                    pattern_shift <= pattern_shift;
                    load_cnt <= load_cnt;

                    // On entering COUNT state, initialize counters
                    if (prev_state != COUNT) begin
                        block_cnt <= delay + 1;  // number of 1000-cycle blocks
                        cycle_cnt <= 10'd0;
                    end else begin
                        // count cycles 0..999
                        if (cycle_cnt == 10'd999) begin
                            cycle_cnt <= 10'd0;
                            if (block_cnt != 0)
                                block_cnt <= block_cnt - 1'b1;
                        end else begin
                            cycle_cnt <= cycle_cnt + 1'b1;
                        end
                    end

                    counting <= 1'b1;
                    done <= 1'b0;

                    // count output: remaining blocks minus 1, saturate at 0
                    if (block_cnt == 0)
                        count <= 4'd0;
                    else
                        count <= block_cnt[3:0] - 1'b1;
                end

                DONE: begin
                    // Freeze all registers except outputs
                    pattern_shift <= pattern_shift;
                    load_cnt <= load_cnt;
                    delay <= delay;
                    cycle_cnt <= cycle_cnt;
                    block_cnt <= block_cnt;

                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'b0000;

                    // Wait for ack to restart FSM (handled by state transition)
                end

                default: begin
                    state <= SEARCH;
                    pattern_shift <= 4'b0000;
                    delay <= 4'b0000;
                    load_cnt <= 3'd0;
                    cycle_cnt <= 10'd0;
                    block_cnt <= 5'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0000;
                end
            endcase
        end
    end

endmodule