module TopModule (
    input  wire       clk,
    input  wire       reset,   // synchronous active-high reset
    input  wire       data,
    output reg [3:0]  count,
    output reg        counting,
    output reg        done,
    input  wire       ack
);

    // State encoding
    localparam IDLE  = 3'b001;
    localparam LOAD  = 3'b010;
    localparam COUNT = 3'b100;
    localparam DONE  = 3'b000;  // encoded as zero for clarity (one-hot not mandatory here)

    reg [2:0] state, next_state;

    // Pattern detection shift register (4 bits)
    reg [3:0] pattern_shift;

    // Delay loading register (4 bits)
    reg [3:0] delay_reg;

    // Counter for how many delay bits loaded (0 to 4)
    reg [2:0] delay_bits_cnt;

    // Timer counters
    reg [9:0] cycle_counter;   // 0..999 counts cycles within one tick
    reg [3:0] tick_counter;    // counts remaining ticks (delay+1)

    // Signals to identify state transitions
    wire entering_load  = (state != LOAD)  && (next_state == LOAD);
    wire entering_count = (state != COUNT) && (next_state == COUNT);
    wire entering_done  = (state != DONE)  && (next_state == DONE);

    // Pattern detection logic: shift in only in IDLE
    always @(posedge clk) begin
        if (reset) begin
            pattern_shift <= 4'b0;
        end else if (state == IDLE) begin
            pattern_shift <= {pattern_shift[2:0], data};
        end
    end

    // Delay bits loading logic (MSB first): shift left, insert data at LSB
    always @(posedge clk) begin
        if (reset) begin
            delay_reg <= 4'b0;
            delay_bits_cnt <= 3'b0;
        end else if (state == LOAD) begin
            delay_reg <= {delay_reg[2:0], data};
            delay_bits_cnt <= delay_bits_cnt + 1'b1;
        end else if (state == IDLE) begin
            // Clear delay registers when searching again
            delay_reg <= 4'b0;
            delay_bits_cnt <= 3'b0;
        end
    end

    // Next state logic combinational
    always @(*) begin
        case(state)
            IDLE: begin
                if (pattern_shift == 4'b1101)
                    next_state = LOAD;
                else
                    next_state = IDLE;
            end
            LOAD: begin
                if (delay_bits_cnt == 4)
                    next_state = COUNT;
                else
                    next_state = LOAD;
            end
            COUNT: begin
                if (tick_counter == 0 && cycle_counter == 10'd999)
                    next_state = DONE;
                else
                    next_state = COUNT;
            end
            DONE: begin
                if (ack)
                    next_state = IDLE;
                else
                    next_state = DONE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: state register update
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Timer counters and outputs
    always @(posedge clk) begin
        if (reset) begin
            cycle_counter <= 10'd0;
            tick_counter <= 4'd0;
            count <= 4'b0000;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            case(state)
                IDLE: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;
                    count <= 4'b0000; // don't-care, but assign zero for cleanliness
                end
                LOAD: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;
                    count <= 4'b0000;
                end
                COUNT: begin
                    counting <= 1'b1;
                    done <= 1'b0;
                    // On entry to COUNT, initialize counters
                    if (entering_count) begin
                        // delay_reg has delay bits MSB first loaded correctly here
                        tick_counter <= delay_reg + 1'b1;  // number of 1000-cycle ticks
                        cycle_counter <= 10'd0;
                        count <= delay_reg + 1'b1;
                    end else begin
                        // Counting logic
                        if (cycle_counter == 10'd999) begin
                            cycle_counter <= 10'd0;
                            if (tick_counter != 0) begin
                                tick_counter <= tick_counter - 1'b1;
                                count <= tick_counter - 1'b1;
                            end else begin
                                count <= 4'd0;
                            end
                        end else begin
                            cycle_counter <= cycle_counter + 1'b1;
                            // Hold count steady during 1000 cycle intervals
                            count <= tick_counter;
                        end
                    end
                end
                DONE: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;
                    count <= 4'bxxxx; // don't-care
                end
                default: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;
                    count <= 4'b0000;
                end
            endcase
        end
    end

endmodule