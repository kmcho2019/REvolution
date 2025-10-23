module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output counting,
    output done,
    input ack
);

    // FSM states
    localparam IDLE      = 0;
    localparam READ_DELAY = 1;
    localparam COUNTING  = 2;
    localparam DONE      = 3;

    reg [1:0] state, next_state;
    reg [3:0] pattern_reg;
    reg [3:0] delay_reg;
    reg [3:0] delay_counter;
    reg [9:0] cycle_counter;
    reg [1:0] bit_counter;

    // Pattern detection
    always @(posedge clk) begin
        if (reset || (state == DONE && ack)) begin
            pattern_reg <= 4'b0;
        end else if (state == IDLE) begin
            pattern_reg <= {pattern_reg[2:0], data};
        end
    end

    // Delay capture
    always @(posedge clk) begin
        if (reset || (state == DONE && ack)) begin
            delay_reg <= 4'b0;
        end else if (state == READ_DELAY) begin
            if (bit_counter < 3) begin
                delay_reg <= {delay_reg[2:0], data};
            end
        end
    end

    // Bit counter for delay reading
    always @(posedge clk) begin
        if (reset || state != READ_DELAY) begin
            bit_counter <= 0;
        end else begin
            bit_counter <= bit_counter + 1;
        end
    end

    // Main cycle counter
    always @(posedge clk) begin
        if (reset || state != COUNTING) begin
            cycle_counter <= 0;
        end else if (cycle_counter == 999) begin
            cycle_counter <= 0;
        end else begin
            cycle_counter <= cycle_counter + 1;
        end
    end

    // Delay counter
    always @(posedge clk) begin
        if (reset || state != COUNTING) begin
            delay_counter <= delay_reg;
        end else if (cycle_counter == 999) begin
            delay_counter <= delay_counter - 1;
        end
    end

    // State transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: 
                if (pattern_reg == 4'b1101) 
                    next_state = READ_DELAY;
            READ_DELAY:
                if (bit_counter == 3) 
                    next_state = COUNTING;
            COUNTING:
                if (cycle_counter == 999 && delay_counter == 0) 
                    next_state = DONE;
            DONE:
                if (ack) 
                    next_state = IDLE;
        endcase
    end

    // Output logic
    assign counting = (state == COUNTING);
    assign done = (state == DONE);
    
    always @(*) begin
        if (state == COUNTING) begin
            count = delay_counter;
        end else begin
            count = 4'b0; // Don't care when not counting
        end
    end

endmodule