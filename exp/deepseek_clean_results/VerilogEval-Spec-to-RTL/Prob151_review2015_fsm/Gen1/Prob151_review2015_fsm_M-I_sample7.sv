module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

    // One-hot state encoding
    localparam [3:0]
        IDLE  = 4'b0001,
        SHIFT = 4'b0010,
        COUNT = 4'b0100,
        DONE  = 4'b1000;

    reg [3:0] state, next_state;
    reg [1:0] shift_counter;  // Counts 0-3 (4 cycles)

    // Pattern detection shift register
    reg [3:0] pattern_reg;

    // State register
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            shift_counter <= 2'b0;
        end else begin
            state <= next_state;
            pattern_reg <= {pattern_reg[2:0], data};
            
            if (state == SHIFT) begin
                shift_counter <= shift_counter + 1;
            end else begin
                shift_counter <= 2'b0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;  // Default stay in current state
        
        case (state)
            IDLE: begin
                if (pattern_reg == 4'b1101) begin
                    next_state = SHIFT;
                end
            end
            
            SHIFT: begin
                if (shift_counter == 2'b11) begin  // After 4 cycles
                    next_state = COUNT;
                end
            end
            
            COUNT: begin
                if (done_counting) begin
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

    // Output logic - purely combinatorial
    always @(*) begin
        shift_ena = (state == SHIFT);
        counting = (state == COUNT);
        done = (state == DONE);
    end

endmodule