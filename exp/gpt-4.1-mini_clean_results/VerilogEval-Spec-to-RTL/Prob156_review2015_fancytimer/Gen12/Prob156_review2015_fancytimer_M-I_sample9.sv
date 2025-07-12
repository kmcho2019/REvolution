module TopModule(
    input        clk,
    input        reset, // synchronous active high
    input        data,
    output reg [3:0] count,
    output reg   counting,
    output reg   done,
    input        ack
);

    // State encoding using parameters (pure Verilog)
    parameter SEARCH     = 2'd0;
    parameter LOAD_DELAY = 2'd1;
    parameter COUNTING   = 2'd2;
    parameter DONE_WAIT  = 2'd3;

    reg [1:0] state, next_state;

    reg [3:0] pattern_shift;     // For detecting pattern 1101 in SEARCH
    reg [3:0] delay_reg;         // Stores 4 delay bits MSB first
    reg [2:0] load_count;        // Counts bits loaded (0 to 4)
    reg [9:0] cycle_count;       // Counts 0..999 for 1000 cycles
    reg [4:0] tick_count;        // Counts delay+1 ticks (max 17 fits in 5 bits)

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'd0;
            delay_reg <= 4'd0;
            load_count <= 3'd0;
            cycle_count <= 10'd0;
            tick_count <= 5'd0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'd0;
        end else begin
            state <= next_state;

            case (state)
                SEARCH: begin
                    // Shift pattern_shift in data bit (LSB is newest)
                    pattern_shift <= {pattern_shift[2:0], data};
                    // Reset load_count and counters here to avoid latches
                    load_count <= 3'd0;
                    cycle_count <= 10'd0;
                    tick_count <= 5'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end
                LOAD_DELAY: begin
                    // Shift in delay bits MSB first: new bit at MSB, shift right
                    delay_reg <= {data, delay_reg[3:1]};
                    load_count <= load_count + 1'b1;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                    cycle_count <= 10'd0;
                    tick_count <= 5'd0;
                end
                COUNTING: begin
                    counting <= 1'b1;
                    done <= 1'b0;

                    if (cycle_count == 10'd999) begin
                        cycle_count <= 10'd0;
                        if (tick_count != 5'd0)
                            tick_count <= tick_count - 1'b1;
                    end else begin
                        cycle_count <= cycle_count + 1'b1;
                    end

                    // Output count = tick_count during each 1000-cycle interval:
                    // For 1000 cycles show the current tick_count - 1 (except when tick_count==0)
                    if (tick_count == 5'd0) begin
                        count <= 4'd0;
                    end else if (cycle_count == 10'd999) begin
                        count <= tick_count[3:0];
                    end else begin
                        count <= (tick_count - 5'd1)[3:0];
                    end
                end
                DONE_WAIT: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'd0;
                    cycle_count <= 10'd0;
                    tick_count <= 5'd0;
                    // delay_reg, load_count, pattern_shift retain their last values or don't matter here
                end
            endcase

            // Load tick_count when transitioning from LOAD_DELAY to COUNTING
            if (state == LOAD_DELAY && next_state == COUNTING) begin
                tick_count <= {1'b0, delay_reg} + 5'd1; // delay + 1
                cycle_count <= 10'd0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            SEARCH: begin
                if (pattern_shift == 4'b1101)
                    next_state = LOAD_DELAY;
            end
            LOAD_DELAY: begin
                if (load_count == 3'd4)
                    next_state = COUNTING;
            end
            COUNTING: begin
                if (tick_count == 5'd0 && cycle_count == 10'd999)
                    next_state = DONE_WAIT;
            end
            DONE_WAIT: begin
                if (ack)
                    next_state = SEARCH;
            end
        endcase
    end

endmodule