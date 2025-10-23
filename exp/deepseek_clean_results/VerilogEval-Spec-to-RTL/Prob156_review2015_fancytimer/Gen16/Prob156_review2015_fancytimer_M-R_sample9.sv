module TopModule (
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

    // State encoding
    localparam IDLE     = 2'b00;
    localparam CAPTURE  = 2'b01;
    localparam COUNTING = 2'b10;
    localparam DONE     = 2'b11;

    reg [1:0] state, next_state;
    reg [3:0] pattern_reg;
    reg [3:0] delay_reg;
    reg [2:0] bit_counter;
    reg [15:0] main_counter;
    reg [9:0] cycle_counter;  // Counts 0-999 for each delay step

    // Pattern detection shift register
    always @(posedge clk) begin
        if (reset || (state == DONE && ack))
            pattern_reg <= 4'b0;
        else if (state == IDLE)
            pattern_reg <= {pattern_reg[2:0], data};
    end

    // Delay value capture
    always @(posedge clk) begin
        if (reset)
            delay_reg <= 4'b0;
        else if (state == CAPTURE)
            delay_reg <= {delay_reg[2:0], data};
    end

    // Bit counter for pattern and delay capture
    always @(posedge clk) begin
        if (reset || (state == DONE && ack))
            bit_counter <= 3'b0;
        else if ((state == IDLE && bit_counter == 3'd3) || 
                (state == CAPTURE && bit_counter == 3'd3))
            bit_counter <= 3'b0;
        else if (state == IDLE || state == CAPTURE)
            bit_counter <= bit_counter + 1;
    end

    // Main counter for total cycles
    always @(posedge clk) begin
        if (reset || (state == DONE && ack))
            main_counter <= 16'b0;
        else if (state == COUNTING)
            main_counter <= main_counter + 1;
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

    // State transition logic
    always @(*) begin
        case (state)
            IDLE: next_state = (pattern_reg == 4'b1101 && bit_counter == 3'd3) ? CAPTURE : IDLE;
            CAPTURE: next_state = (bit_counter == 3'd3) ? COUNTING : CAPTURE;
            COUNTING: next_state = (main_counter == (delay_reg + 1) * 1000 - 1) ? DONE : COUNTING;
            DONE: next_state = ack ? IDLE : DONE;
            default: next_state = IDLE;
        endcase
    end

    // State register
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Output assignments
    assign counting = (state == COUNTING);
    assign done = (state == DONE);
    assign count = (state == COUNTING) ? (delay_reg - (main_counter / 1000)) : 4'b0;

endmodule