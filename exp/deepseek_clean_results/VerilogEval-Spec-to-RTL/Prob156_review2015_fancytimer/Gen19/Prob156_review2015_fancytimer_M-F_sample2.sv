module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    // State encoding
    localparam IDLE     = 3'b000;
    localparam CAPTURE  = 3'b001;
    localparam COUNTING = 3'b010;
    localparam DONE     = 3'b100;

    reg [2:0] state, next_state;
    reg [3:0] pattern_reg;
    reg pattern_match;
    reg [3:0] delay_value;
    reg [15:0] cycle_counter;
    reg [3:0] bit_counter;
    reg [3:0] remaining_blocks;

    // Pattern detection
    always @(posedge clk) begin
        if (reset) begin
            pattern_reg <= 4'b0;
            pattern_match <= 1'b0;
        end else if (state == IDLE) begin
            pattern_reg <= {pattern_reg[2:0], data};
            pattern_match <= (pattern_reg == 4'b1101);
        end else begin
            pattern_match <= 1'b0;
        end
    end

    // State machine and delay capture
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            delay_value <= 4'b0;
            bit_counter <= 4'b0;
            cycle_counter <= 16'b0;
            remaining_blocks <= 4'b0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    if (pattern_match) begin
                        bit_counter <= 4'b0;
                        delay_value <= 4'b0;
                    end
                end
                
                CAPTURE: begin
                    if (bit_counter < 4) begin
                        delay_value <= {delay_value[2:0], data};
                        bit_counter <= bit_counter + 1;
                    end
                end
                
                COUNTING: begin
                    if (cycle_counter == 999) begin
                        cycle_counter <= 0;
                        remaining_blocks <= remaining_blocks - 1;
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
            IDLE:    if (pattern_match) next_state = CAPTURE;
            CAPTURE: if (bit_counter == 4) next_state = COUNTING;
            COUNTING: if (remaining_blocks == 0 && cycle_counter == 999) next_state = DONE;
            DONE:    if (ack) next_state = IDLE;
        endcase
    end

    // Output assignments
    always @(posedge clk) begin
        if (reset) begin
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0;
        end else begin
            counting <= (state == COUNTING);
            done <= (state == DONE);
            
            if (state == COUNTING) begin
                if (next_state == COUNTING && cycle_counter == 999) begin
                    count <= remaining_blocks - 1;
                end else if (next_state == COUNTING) begin
                    count <= remaining_blocks;
                end
            end else if (state == CAPTURE && next_state == COUNTING) begin
                count <= delay_value;
                remaining_blocks <= delay_value;
            end else if (state != COUNTING) begin
                count <= 4'b0; // Don't-care when not counting
            end
        end
    end

endmodule