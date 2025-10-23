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
    reg [1:0] shift_counter;
    reg [3:0] pattern_reg;

    // State transition logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (pattern_reg == 4'b1101)
                    next_state = SHIFT;
                else
                    next_state = IDLE;
            end
            SHIFT: begin
                if (shift_counter == 2'b11)
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

    // State register and pattern detection
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            shift_counter <= 2'b0;
        end else begin
            state <= next_state;
            
            // Pattern detection shift register
            if (state == IDLE)
                pattern_reg <= {pattern_reg[2:0], data};
            else
                pattern_reg <= 4'b0;
                
            // Shift counter
            if (state == SHIFT)
                shift_counter <= shift_counter + 1;
            else
                shift_counter <= 2'b0;
        end
    end

    // Output assignments
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == COUNTING);
    assign done      = (state == DONE);

endmodule