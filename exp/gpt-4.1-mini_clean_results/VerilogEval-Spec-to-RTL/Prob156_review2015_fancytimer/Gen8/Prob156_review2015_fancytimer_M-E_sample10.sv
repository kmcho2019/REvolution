module TopModule (
    input        clk,
    input        reset,  // synchronous active-high reset
    input        data,
    output reg [3:0] count,
    output reg       counting,
    output reg       done,
    input        ack
);

    // State encoding
    localparam SEARCH      = 3'd0;
    localparam LOAD_DELAY  = 3'd1;
    localparam COUNT       = 3'd2;
    localparam DONE_STATE  = 3'd3;

    reg [2:0] state;

    // Shift register for pattern detection (last 4 bits)
    reg [3:0] pattern_shift;

    // Delay register - 4 bits loaded MSB-first
    reg [3:0] delay_reg;
    reg [2:0] bits_loaded; // counts 0..3 bits during LOAD_DELAY

    // Countdown timer counter: max (delay+1)*1000 = 16*1000 = 16000 max; needs 15 bits to count down from 16000
    reg [14:0] cycle_counter; // enough for 0 to 16000 cycles

    // Internal signals
    wire pattern_detected = (pattern_shift == 4'b1101);

    // Integer division to get current chunk: count = cycle_counter / 1000
    // Implemented as combinational logic by comparing cycle_counter against multiples of 1000
    // Because maximum delay=15, max cycle_counter=16000 so max count=15
    function [3:0] calc_count;
        input [14:0] val;
        integer i;
        begin
            // Find count = ceil(val/1000)-1 if val>0 else 0
            // Actually, we want count = floor(val/1000), counting down from delay to 0
            // Use a loop from 15 down to 0 to find largest i*1000 <= val
            calc_count = 0;
            for (i = 15; i >= 0; i = i - 1) begin
                if (val >= i*1000) begin
                    calc_count = i[3:0];
                    disable for;
                end
            end
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'd0;
            delay_reg <= 4'd0;
            bits_loaded <= 3'd0;
            cycle_counter <= 15'd0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'd0;
        end else begin
            case (state)
                SEARCH: begin
                    // Shift in the incoming bit for pattern detection
                    pattern_shift <= {pattern_shift[2:0], data};
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'bxxxx; // don't care when not counting

                    if (pattern_detected) begin
                        // Start loading delay bits next clock cycle
                        delay_reg <= 4'd0;
                        bits_loaded <= 3'd0;
                        state <= LOAD_DELAY;
                    end
                end

                LOAD_DELAY: begin
                    // Shift in delay bits MSB-first: shift left and add data at LSB
                    delay_reg <= {delay_reg[2:0], data};
                    bits_loaded <= bits_loaded + 3'd1;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'bxxxx; // don't care while loading

                    if (bits_loaded == 3'd3) begin
                        // All 4 bits loaded (bits_loaded counts 0..3)
                        // Initialize cycle_counter to (delay+1)*1000 for counting down
                        cycle_counter <= ( {11'd0, delay_reg} + 15'd1 ) * 15'd1000;
                        state <= COUNT;
                    end
                end

                COUNT: begin
                    counting <= 1'b1;
                    done <= 1'b0;
                    // Calculate current count chunk from cycle_counter
                    count <= calc_count(cycle_counter);

                    if (cycle_counter == 15'd0) begin
                        // Counting done
                        state <= DONE_STATE;
                        counting <= 1'b0;
                        done <= 1'b1;
                        count <= 4'd0; // don't care in done state
                    end else begin
                        cycle_counter <= cycle_counter - 15'd1;
                    end
                end

                DONE_STATE: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'bxxxx; // don't care in done state
                    pattern_shift <= 4'd0; // clear pattern register

                    if (ack) begin
                        // Wait for ack to return to searching
                        state <= SEARCH;
                        delay_reg <= 4'd0;
                        bits_loaded <= 3'd0;
                        cycle_counter <= 15'd0;
                    end
                end

                default: begin
                    // Defensive reset
                    state <= SEARCH;
                    pattern_shift <= 4'd0;
                    delay_reg <= 4'd0;
                    bits_loaded <= 3'd0;
                    cycle_counter <= 15'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end
            endcase
        end
    end

endmodule