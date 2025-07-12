module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output shift_ena,
    output counting,
    output done
);

    // One-hot state encoding
    localparam IDLE     = 4'b0001;
    localparam SHIFT    = 4'b0010;
    localparam COUNTING = 4'b0100;
    localparam DONE     = 4'b1000;

    reg [3:0] state;
    reg [3:0] next_state;
    reg [3:0] pattern_reg;  // Stores incoming pattern bits
    reg [1:0] shift_count;  // Counts shift cycles (0-3)

    // Pattern detection and state transition logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (pattern_reg == 4'b1101)
                    next_state = SHIFT;
                else
                    next_state = IDLE;
            end

            SHIFT: begin
                if (shift_count == 2'b11)
                    next_state = COUNTING;
                else
                    next_state = SHIFT;
            end

            COUNTING: begin
                if (done_counting)
                    next_state = DONE;
                else
                    next_state = COUNTING;
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

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            shift_count <= 2'b0;
        end else begin
            state <= next_state;

            // Pattern register shifts in new data when in IDLE
            if (state == IDLE)
                pattern_reg <= {pattern_reg[2:0], data};

            // Shift counter increments when in SHIFT state
            if (state == SHIFT)
                shift_count <= shift_count + 1;
            else
                shift_count <= 2'b0;
        end
    end

    // Output assignments
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == COUNTING);
    assign done      = (state == DONE);

endmodule