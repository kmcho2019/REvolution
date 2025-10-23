module TopModule(
    input clk,
    input reset, // synchronous active high
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    // FSM states
    localparam S_SEARCH    = 3'd0;
    localparam S_LOAD      = 3'd1;
    localparam S_COUNTING  = 3'd2;
    localparam S_DONE_WAIT = 3'd3;

    reg [2:0] state, next_state;

    // For sequence detection of "1101"
    reg [3:0] seq_shift;

    // For loading 4-bit delay MSB first
    reg [3:0] delay_shift;
    reg [2:0] load_bits; // count how many delay bits loaded [0..4]

    // Timer counters
    reg [9:0] cycle_counter; // counts 0..999 for 1000 cycles
    reg [4:0] ticks_remaining; // number of 1000-cycle ticks remaining: (delay+1) max 17, needs 5 bits

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= S_SEARCH;
            seq_shift <= 4'd0;
            delay_shift <= 4'd0;
            load_bits <= 3'd0;
            cycle_counter <= 10'd0;
            ticks_remaining <= 5'd0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'd0;
        end else begin
            state <= next_state;

            case (state)
                S_SEARCH: begin
                    // Shift sequence in LSB first (old bits shift left, new bit at LSB)
                    // But pattern is 1101 = bits[3:0], we want to detect that pattern.
                    seq_shift <= {seq_shift[2:0], data};
                    delay_shift <= 4'd0;
                    load_bits <= 3'd0;
                    cycle_counter <= 10'd0;
                    ticks_remaining <= 5'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end
                S_LOAD: begin
                    // Shift delay bits MSB first: new bit inserted at MSB, old bits shifted right
                    // Because the problem wants MSB first shifting.
                    delay_shift <= {delay_shift[2:1], data};
                    load_bits <= load_bits + 1'b1;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                    cycle_counter <= 10'd0;
                    ticks_remaining <= 5'd0;
                    // seq_shift no longer updated
                end
                S_COUNTING: begin
                    counting <= 1'b1;
                    done <= 1'b0;
                    // Timer counting logic: count 1000 cycles, then decrement ticks_remaining

                    if (cycle_counter == 10'd999) begin
                        cycle_counter <= 10'd0;
                        if (ticks_remaining != 5'd0)
                            ticks_remaining <= ticks_remaining - 1'b1;
                    end else begin
                        cycle_counter <= cycle_counter + 1'b1;
                    end

                    // Output count is ticks_remaining during counting
                    count <= ticks_remaining[3:0];
                    // seq_shift and delay_shift not updated here
                end
                S_DONE_WAIT: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'd0;
                    cycle_counter <= 10'd0;
                    ticks_remaining <= 5'd0;
                    // Wait for ack, no updates to seq_shift or delay_shift
                end
                default: begin
                    // Safety fallback
                    state <= S_SEARCH;
                    seq_shift <= 4'd0;
                    delay_shift <= 4'd0;
                    load_bits <= 3'd0;
                    cycle_counter <= 10'd0;
                    ticks_remaining <= 5'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end
            endcase

            // When moving from LOAD to COUNTING, initialize ticks_remaining
            if (state == S_LOAD && next_state == S_COUNTING) begin
                // delay_shift now holds the loaded 4-bit delay in MSB-first order
                // Convert delay_shift to integer, then add 1, max 17 ticks needed
                ticks_remaining <= delay_shift + 5'd1;
                cycle_counter <= 10'd0;
            end
        end
    end

    // Next state logic combinational
    always @(*) begin
        next_state = state;
        case (state)
            S_SEARCH: begin
                // Pattern to detect is 1101 (bit3=1, bit2=1, bit1=0, bit0=1)
                // seq_shift has newest bit at LSB, so bits are:
                // seq_shift[3] oldest bit, seq_shift[0] newest bit.
                // We shifted data in at LSB, so current 4 bits represent the last 4 data bits in order received.
                // To detect pattern "1101", check seq_shift == 4'b1101.
                if (seq_shift == 4'b1101)
                    next_state = S_LOAD;
            end
            S_LOAD: begin
                if (load_bits == 3'd4)
                    next_state = S_COUNTING;
            end
            S_COUNTING: begin
                // When ticks_remaining is zero and cycle_counter reaches 999, counting done
                if (ticks_remaining == 5'd0 && cycle_counter == 10'd999)
                    next_state = S_DONE_WAIT;
            end
            S_DONE_WAIT: begin
                if (ack)
                    next_state = S_SEARCH;
            end
        endcase
    end

endmodule