module TopModule (
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

    // One-hot state encoding
    localparam IDLE     = 4'b0001;
    localparam CAPTURE  = 4'b0010;
    localparam COUNTING = 4'b0100;
    localparam DONE     = 4'b1000;

    reg [3:0] state;
    reg [3:0] pattern_reg;
    reg [3:0] delay_reg;
    reg [3:0] count_reg;
    reg [9:0] cycle_counter;
    reg [1:0] bit_counter;

    // Pattern detection shift register
    always @(posedge clk) begin
        if (reset || (state == DONE && ack))
            pattern_reg <= 4'b0;
        else if (state == IDLE)
            pattern_reg <= {pattern_reg[2:0], data};
    end

    // Delay value capture
    always @(posedge clk) begin
        if (reset || (state == DONE && ack))
            delay_reg <= 4'b0;
        else if (state == CAPTURE)
            delay_reg <= {delay_reg[2:0], data};
    end

    // Bit counter for pattern and delay capture
    always @(posedge clk) begin
        if (reset || (state == DONE && ack))
            bit_counter <= 2'b0;
        else if ((state == IDLE && pattern_reg == 4'b1101) || 
                (state == CAPTURE && bit_counter == 2'b11))
            bit_counter <= 2'b0;
        else if (state == IDLE || state == CAPTURE)
            bit_counter <= bit_counter + 1;
    end

    // Countdown timer
    always @(posedge clk) begin
        if (reset || (state == DONE && ack))
            count_reg <= 4'b0;
        else if (state == COUNTING) begin
            if (cycle_counter == 10'd999) begin
                cycle_counter <= 10'b0;
                count_reg <= count_reg - 1;
            end
        end
        else if (state == CAPTURE && bit_counter == 2'b11)
            count_reg <= delay_reg;
    end

    // Cycle counter for 1000-cycle intervals
    always @(posedge clk) begin
        if (reset || (state == DONE && ack))
            cycle_counter <= 10'b0;
        else if (state == COUNTING) begin
            if (cycle_counter == 10'd999)
                cycle_counter <= 10'b0;
            else
                cycle_counter <= cycle_counter + 1;
        end
    end

    // State transitions
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else case (state)
            IDLE:    if (pattern_reg == 4'b1101) state <= CAPTURE;
            CAPTURE:  if (bit_counter == 2'b11) state <= COUNTING;
            COUNTING: if (count_reg == 4'b0 && cycle_counter == 10'd999) state <= DONE;
            DONE:     if (ack) state <= IDLE;
            default:  state <= IDLE;
        endcase
    end

    // Output assignments
    assign counting = (state == COUNTING);
    assign done = (state == DONE);
    assign count = (state == COUNTING) ? count_reg : 4'b0;

endmodule