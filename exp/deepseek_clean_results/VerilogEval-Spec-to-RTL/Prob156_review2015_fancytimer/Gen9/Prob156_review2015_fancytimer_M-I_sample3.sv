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
    localparam IDLE     = 2'b00;
    localparam CAPTURE  = 2'b01;
    localparam COUNTING = 2'b10;
    localparam DONE     = 2'b11;

    reg [1:0] state, next_state;
    reg [3:0] pattern_reg;    // For detecting 1101
    reg [3:0] delay_val;      // Captured delay value
    reg [3:0] periods_left;   // Tracks remaining periods
    reg [9:0] cycle_counter;  // Counts 0-999 cycles per period
    reg [2:0] bit_counter;

    // Pattern detection and FSM control
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            delay_val <= 4'b0;
            periods_left <= 4'b0;
            cycle_counter <= 0;
            bit_counter <= 0;
        end else begin
            state <= next_state;
            
            case (state)
                IDLE: begin
                    pattern_reg <= {pattern_reg[2:0], data};
                    if (pattern_reg == 4'b1101) begin
                        bit_counter <= 0;
                    end
                end
                
                CAPTURE: begin
                    if (bit_counter < 4) begin
                        delay_val <= {delay_val[2:0], data};
                        bit_counter <= bit_counter + 1;
                    end
                end
                
                COUNTING: begin
                    if (cycle_counter == 999) begin
                        cycle_counter <= 0;
                        periods_left <= periods_left - 1;
                    end else begin
                        cycle_counter <= cycle_counter + 1;
                    end
                end
                
                DONE: begin
                    if (ack) begin
                        pattern_reg <= 4'b0;
                    end
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: 
                if (pattern_reg == 4'b1101) 
                    next_state = CAPTURE;
            CAPTURE: 
                if (bit_counter == 4) 
                    next_state = COUNTING;
            COUNTING: 
                if (periods_left == 0 && cycle_counter == 999) 
                    next_state = DONE;
            DONE: 
                if (ack) 
                    next_state = IDLE;
        endcase
    end

    // Output logic
    always @(posedge clk) begin
        if (reset) begin
            counting <= 0;
            done <= 0;
            count <= 4'b0;
        end else begin
            counting <= (state == COUNTING);
            done <= (state == DONE);
            
            if (state == COUNTING) begin
                count <= periods_left;
            end else begin
                count <= 4'b0;
            end
        end
    end

    // Initialize counting parameters when entering COUNTING state
    always @(posedge clk) begin
        if (state == CAPTURE && next_state == COUNTING) begin
            periods_left <= delay_val;
            cycle_counter <= 0;
        end
    end

endmodule