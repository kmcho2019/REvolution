module TopModule (
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

    // FSM states
    localparam IDLE       = 2'b00;
    localparam READ_DELAY = 2'b01;
    localparam COUNTING   = 2'b10;
    localparam DONE       = 2'b11;

    reg [1:0] state, next_state;
    reg [3:0] pattern_reg;
    reg [3:0] delay_reg;
    reg [3:0] delay_value;
    reg [15:0] cycle_counter; // Large enough for (15+1)*1000 = 16000 cycles
    reg [2:0] bit_counter;

    // Pattern detection shift register
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
            bit_counter <= 0;
        end else if (state == READ_DELAY) begin
            delay_reg <= {delay_reg[2:0], data};
            bit_counter <= bit_counter + 1;
        end
    end

    // Store delay value when complete
    always @(posedge clk) begin
        if (reset) begin
            delay_value <= 4'b0;
        end else if (state == READ_DELAY && bit_counter == 3'd3) begin
            delay_value <= delay_reg;
        end else if (state == COUNTING && 
                   cycle_counter == (delay_value * 1000 + 999)) begin
            delay_value <= delay_value - 1;
        end
    end

    // Cycle counter for timing
    always @(posedge clk) begin
        if (reset) begin
            cycle_counter <= 0;
        end else if (state == COUNTING) begin
            if (cycle_counter == (delay_value * 1000 + 999)) begin
                cycle_counter <= 0;
            end else begin
                cycle_counter <= cycle_counter + 1;
            end
        end else begin
            cycle_counter <= 0;
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

    // FSM next state logic (combinational)
    always @(*) begin
        case (state)
            IDLE: next_state = (pattern_reg == 4'b1101) ? READ_DELAY : IDLE;
            READ_DELAY: next_state = (bit_counter == 3'd3) ? COUNTING : READ_DELAY;
            COUNTING: next_state = (delay_value == 0 && 
                                   cycle_counter == 999) ? DONE : COUNTING;
            DONE: next_state = ack ? IDLE : DONE;
            default: next_state = IDLE;
        endcase
    end

    // Output assignments
    assign counting = (state == COUNTING);
    assign done = (state == DONE);
    assign count = (state == COUNTING) ? delay_value : 4'b0;

endmodule