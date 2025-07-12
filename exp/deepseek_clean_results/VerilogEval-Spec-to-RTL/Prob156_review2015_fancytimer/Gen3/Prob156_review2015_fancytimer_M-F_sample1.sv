module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output counting,
    output done,
    input ack
);

    // State encoding
    localparam [1:0] 
        IDLE       = 2'b00,
        READ_DELAY = 2'b01,
        COUNTING   = 2'b10,
        DONE       = 2'b11;

    reg [1:0] state, next_state;
    reg [3:0] pattern_reg;    // Shift register for pattern detection
    reg [3:0] delay_reg;      // Shift register for delay value
    reg [1:0] bits_read;      // Count of delay bits read (0-3)
    reg [9:0] cycle_counter;  // Counts 0-999 (1000 cycles)
    reg [3:0] delay_counter;  // Current delay countdown value

    // Output assignments
    assign counting = (state == COUNTING);
    assign done = (state == DONE);

    // Main state machine and counters
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            delay_reg <= 4'b0;
            bits_read <= 2'b0;
            cycle_counter <= 10'b0;
            delay_counter <= 4'b0;
            count <= 4'b0;
        end else begin
            state <= next_state;
            
            case (state)
                IDLE: begin
                    pattern_reg <= {pattern_reg[2:0], data};
                    cycle_counter <= 10'b0;
                end

                READ_DELAY: begin
                    if (bits_read < 3) begin
                        delay_reg <= {delay_reg[2:0], data};
                        bits_read <= bits_read + 1;
                    end else begin
                        // On 4th bit, capture delay and initialize counters
                        delay_counter <= {delay_reg[2:0], data};
                        cycle_counter <= 10'b0;
                    end
                end

                COUNTING: begin
                    if (cycle_counter < 10'd999) begin
                        cycle_counter <= cycle_counter + 1;
                    end else begin
                        cycle_counter <= 10'b0;
                        if (delay_counter > 0) begin
                            delay_counter <= delay_counter - 1;
                        end
                    end
                    count <= delay_counter;
                end

                DONE: begin
                    if (ack) begin
                        pattern_reg <= 4'b0;
                        delay_reg <= 4'b0;
                        bits_read <= 2'b0;
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
                    next_state = READ_DELAY;
            
            READ_DELAY: 
                if (bits_read == 3) 
                    next_state = COUNTING;
            
            COUNTING: 
                if (delay_counter == 0 && cycle_counter == 10'd999) 
                    next_state = DONE;
            
            DONE: 
                if (ack) 
                    next_state = IDLE;
        endcase
    end

endmodule