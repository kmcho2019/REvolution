module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    // FSM states
    localparam IDLE       = 2'b00;
    localparam READ_DELAY = 2'b01;
    localparam COUNTING   = 2'b10;
    localparam DONE       = 2'b11;

    reg [1:0] state, next_state;
    reg [3:0] pattern_reg;  // Shift register for 1101 pattern detection
    reg [3:0] delay_reg;    // Shift register for delay value
    reg [3:0] delay_value;  // Stored delay value
    reg [9:0] cycle_counter; // Counts up to 1000 cycles (10 bits for 0-999)
    reg [2:0] bit_counter;  // Counts 0-3 for reading delay bits

    // Pattern detection
    always @(posedge clk) begin
        if (reset) begin
            pattern_reg <= 4'b0;
        end else if (state == IDLE) begin
            pattern_reg <= {pattern_reg[2:0], data};
        end
    end

    // Delay value capture
    always @(posedge clk) begin
        if (reset) begin
            delay_reg <= 4'b0;
            bit_counter <= 3'b0;
        end else if (state == READ_DELAY) begin
            delay_reg <= {delay_reg[2:0], data};
            bit_counter <= bit_counter + 1;
        end else if (state == IDLE) begin
            bit_counter <= 3'b0;
        end
    end

    // Store delay value when complete
    always @(posedge clk) begin
        if (reset) begin
            delay_value <= 4'b0;
        end else if (state == READ_DELAY && bit_counter == 3'b11) begin
            delay_value <= delay_reg;
        end
    end

    // Cycle counter for timing
    always @(posedge clk) begin
        if (reset) begin
            cycle_counter <= 10'b0;
        end else if (state == COUNTING) begin
            if (cycle_counter == 10'd999) begin
                cycle_counter <= 10'b0;
            end else begin
                cycle_counter <= cycle_counter + 1;
            end
        end else begin
            cycle_counter <= 10'b0;
        end
    end

    // Count value output
    always @(posedge clk) begin
        if (reset) begin
            count <= 4'b0;
        end else if (state == COUNTING) begin
            if (cycle_counter == 10'd999) begin
                count <= delay_value - 1;
            end else begin
                count <= delay_value;
            end
        end
    end

    // Delay value decrement
    always @(posedge clk) begin
        if (reset) begin
            delay_value <= 4'b0;
        end else if (state == COUNTING && cycle_counter == 10'd999) begin
            delay_value <= delay_value - 1;
        end
    end

    // FSM state transition
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // FSM next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (pattern_reg == 4'b1101) begin
                    next_state = READ_DELAY;
                end
            end
            READ_DELAY: begin
                if (bit_counter == 3'b11) begin
                    next_state = COUNTING;
                end
            end
            COUNTING: begin
                if (delay_value == 4'b0 && cycle_counter == 10'd999) begin
                    next_state = DONE;
                end
            end
            DONE: begin
                if (ack) begin
                    next_state = IDLE;
                end
            end
        endcase
    end

    // Output logic
    always @(posedge clk) begin
        if (reset) begin
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            counting <= (state == COUNTING);
            done <= (state == DONE);
        end
    end

endmodule