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
    reg [1:0] state, next_state;
    localparam IDLE     = 2'b00;
    localparam SHIFT    = 2'b01;
    localparam COUNTING = 2'b10;
    localparam DONE     = 2'b11;

    // Pattern detection and shift counter
    reg [3:0] pattern_reg;
    reg [1:0] shift_ctr;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            shift_ctr <= 2'b0;
        end else begin
            state <= next_state;
            pattern_reg <= {pattern_reg[2:0], data};
            
            if (state == SHIFT)
                shift_ctr <= shift_ctr + 1'b1;
            else
                shift_ctr <= 2'b0;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE:     next_state = (pattern_reg == 4'b1101) ? SHIFT : IDLE;
            SHIFT:    next_state = (shift_ctr == 2'b11) ? COUNTING : SHIFT;
            COUNTING: next_state = done_counting ? DONE : COUNTING;
            DONE:     next_state = ack ? IDLE : DONE;
            default:  next_state = IDLE;
        endcase
    end

    // Output logic (combinational)
    assign shift_ena = (state == SHIFT);
    assign counting = (state == COUNTING);
    assign done = (state == DONE);

endmodule