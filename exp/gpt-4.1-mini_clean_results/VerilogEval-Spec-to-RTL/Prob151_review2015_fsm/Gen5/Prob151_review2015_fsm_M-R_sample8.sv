module TopModule(
    input  wire clk,
    input  wire reset,
    input  wire data,
    input  wire done_counting,
    input  wire ack,
    output wire shift_ena,
    output wire counting,
    output wire done
);

    // One-hot state encoding
    localparam SEARCH     = 4'b0001;
    localparam SHIFT      = 4'b0010;
    localparam WAIT_COUNT = 4'b0100;
    localparam WAIT_ACK   = 4'b1000;

    reg [3:0] state, next_state;

    reg [3:0] shift_reg;   // shift register for pattern detection
    reg [2:0] shift_cnt;   // counts 0..3 for 4 cycles of shifting

    // Shift in data every clock cycle (always)
    always @(posedge clk) begin
        if (reset)
            shift_reg <= 4'b0000;
        else
            shift_reg <= {shift_reg[2:0], data};
    end

    // State register
    always @(posedge clk) begin
        if (reset)
            state <= SEARCH;
        else
            state <= next_state;
    end

    // Shift counter register
    always @(posedge clk) begin
        if (reset)
            shift_cnt <= 3'd0;
        else if (state == SHIFT)
            shift_cnt <= shift_cnt + 3'd1;
        else
            shift_cnt <= 3'd0;
    end

    // Next state logic
    always @(*) begin
        next_state = state; // default hold
        case (state)
            SEARCH: begin
                if (shift_reg == 4'b1101)
                    next_state = SHIFT;
            end
            SHIFT: begin
                if (shift_cnt == 3'd3) // after 4 cycles (0..3)
                    next_state = WAIT_COUNT;
            end
            WAIT_COUNT: begin
                if (done_counting)
                    next_state = WAIT_ACK;
            end
            WAIT_ACK: begin
                if (ack)
                    next_state = SEARCH;
            end
        endcase
    end

    // Output assignments (Moore outputs)
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == WAIT_COUNT);
    assign done      = (state == WAIT_ACK);

endmodule