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

    // State encoding
    localparam IDLE      = 2'b00;
    localparam SHIFT     = 2'b01;
    localparam COUNT_DONE = 2'b10;

    reg [1:0] state, next_state;
    reg [3:0] pattern_reg;
    reg [1:0] shift_count;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            shift_count <= 2'b0;
        end else begin
            state <= next_state;
            
            // Update pattern register only in IDLE state
            if (state == IDLE)
                pattern_reg <= {pattern_reg[2:0], data};
            
            // Update shift counter only in SHIFT state
            if (state == SHIFT)
                shift_count <= shift_count + 1;
            else
                shift_count <= 2'b0;
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: 
                if (pattern_reg == 4'b1101)
                    next_state = SHIFT;
            
            SHIFT:
                if (shift_count == 2'b11)  // After 4 shifts (0-3)
                    next_state = COUNT_DONE;
            
            COUNT_DONE: begin
                if (!done_counting)
                    next_state = COUNT_DONE;  // Wait for counting
                else if (!ack)
                    next_state = COUNT_DONE;  // Wait for ack
                else
                    next_state = IDLE;       // Return to IDLE
            end
        endcase
    end

    // Output logic
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == COUNT_DONE) && !done_counting;
    assign done      = (state == COUNT_DONE) && done_counting;

endmodule