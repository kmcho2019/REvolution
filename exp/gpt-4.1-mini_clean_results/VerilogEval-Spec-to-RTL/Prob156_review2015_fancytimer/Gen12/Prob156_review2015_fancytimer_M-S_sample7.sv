module TopModule(
    input        clk,
    input        reset, // synchronous active high
    input        data,
    output reg [3:0] count,
    output reg   counting,
    output reg   done,
    input        ack
);

    // State encoding
    parameter SEARCH      = 2'd0;
    parameter LOAD_DELAY  = 2'd1;
    parameter COUNTING    = 2'd2;
    parameter DONE_WAIT   = 2'd3;

    reg [1:0] state, next_state;

    reg [3:0] pattern_shift;  // For detecting pattern 1101
    reg [3:0] delay_reg;      // Delay value shifted in MSB first
    reg [2:0] load_count;     // Count of bits loaded (0 to 4)

    reg [9:0] cycle_count;    // Counts 0..999 clock cycles
    reg [4:0] tick_count;     // Counts delay+1 down to 0

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
                    // Shift pattern shift register left, LSB gets newest bit
                    pattern_shift <= {pattern_shift[2:0], data};
                    // Clear controls
                    load_count <= 3'd0;
                    delay_reg <= delay_reg;
                    cycle_count <= 10'd0;
                    tick_count <= 5'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end

                LOAD_DELAY: begin
                    // Shift delay bits MSB first: shift right, input new bit at MSB
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

                    // Output current remaining count: tick_count-1 during 1000 cycles except last tick
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
                    // delay_reg and load_count do not matter here
                end
            endcase

            // On transition from LOAD_DELAY to COUNTING, initialize tick_count = delay+1
            if (state == LOAD_DELAY && next_state == COUNTING) begin
                tick_count <= delay_reg + 5'd1;
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
                // When tick_count and cycle_count both zero, counting done
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