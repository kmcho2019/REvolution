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
    localparam SEARCH      = 2'd0;
    localparam LOAD_DELAY  = 2'd1;
    localparam COUNTING    = 2'd2;
    localparam DONE_WAIT   = 2'd3;

    reg [1:0] state, next_state;

    reg [3:0] pattern_shift;     // For detecting pattern 1101 in SEARCH
    reg [3:0] delay_reg;         // Stores 4 delay bits MSB first
    reg [2:0] load_count;        // Counts bits loaded (0 to 4)
    reg [9:0] cycle_count;       // Counts 0..999 for 1000 cycles
    reg [4:0] tick_count;        // Counts delay+1 ticks (max 17 fits in 5 bits)

    // State register
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
        end else begin
            state <= next_state;
        end
    end

    // Pattern shift register (only shifts in SEARCH state)
    always @(posedge clk) begin
        if (reset) begin
            pattern_shift <= 4'd0;
        end else if (state == SEARCH) begin
            pattern_shift <= {pattern_shift[2:0], data};
        end
    end

    // Delay register and load counter for LOAD_DELAY state
    always @(posedge clk) begin
        if (reset) begin
            delay_reg <= 4'd0;
            load_count <= 3'd0;
        end else if (state == LOAD_DELAY) begin
            // Shift in data MSB first: new bit shifted into MSB, shift right
            delay_reg <= {data, delay_reg[3:1]};
            load_count <= load_count + 1'b1;
        end else if (state == SEARCH) begin
            // Reset load_count when returning to SEARCH
            load_count <= 3'd0;
            delay_reg <= 4'd0;
        end
    end

    // Counting logic: cycle_count and tick_count
    always @(posedge clk) begin
        if (reset) begin
            cycle_count <= 10'd0;
            tick_count <= 5'd0;
        end else begin
            case(state)
                COUNTING: begin
                    if (cycle_count == 10'd999) begin
                        cycle_count <= 10'd0;
                        if (tick_count != 5'd0)
                            tick_count <= tick_count - 1'b1;
                    end else begin
                        cycle_count <= cycle_count + 1'b1;
                    end
                end
                LOAD_DELAY: begin
                    cycle_count <= 10'd0;
                    tick_count <= 5'd0;
                end
                default: begin
                    cycle_count <= 10'd0;
                    tick_count <= 5'd0;
                end
            endcase
        end
    end

    // On transition from LOAD_DELAY to COUNTING, initialize tick_count to delay+1
    reg prev_state_LOAD_DELAY;
    always @(posedge clk) begin
        if (reset) begin
            prev_state_LOAD_DELAY <= 1'b0;
            tick_count <= 5'd0;
        end else begin
            prev_state_LOAD_DELAY <= (state == LOAD_DELAY);
            if (prev_state_LOAD_DELAY && (state == COUNTING)) begin
                tick_count <= delay_reg + 5'd1;
            end
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            SEARCH: begin
                if (pattern_shift == 4'b1101)
                    next_state = LOAD_DELAY;
            end
            LOAD_DELAY: begin
                if (load_count == 3'd4)
                    next_state = COUNTING;
            end
            COUNTING: begin
                if ((tick_count == 5'd0) && (cycle_count == 10'd999))
                    next_state = DONE_WAIT;
            end
            DONE_WAIT: begin
                if (ack)
                    next_state = SEARCH;
            end
        endcase
    end

    // Output logic
    always @(posedge clk) begin
        if (reset) begin
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'd0;
        end else begin
            case(state)
                SEARCH: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0; // don't care
                end
                LOAD_DELAY: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0; // don't care
                end
                COUNTING: begin
                    counting <= 1'b1;
                    done <= 1'b0;
                    // count shows the current remaining delay value during counting
                    // Output count = tick_count-1 during counting (except when tick_count=0)
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
                    count <= 4'd0; // don't care
                end
            endcase
        end
    end

endmodule