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

    // FSM states
    localparam IDLE     = 2'b00;
    localparam SHIFT    = 2'b01;
    localparam COUNTING = 2'b10;
    localparam DONE     = 2'b11;

    reg [1:0] current_state, next_state;
    reg [3:0] pattern_reg;  // Shift register for pattern detection
    reg [1:0] shift_count;  // Counter for shift cycles

    // State register
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // Pattern detection shift register
    always @(posedge clk) begin
        if (reset) begin
            pattern_reg <= 4'b0;
        end else begin
            pattern_reg <= {pattern_reg[2:0], data};
        end
    end

    // Shift counter
    always @(posedge clk) begin
        if (reset || current_state != SHIFT) begin
            shift_count <= 2'b0;
        end else if (current_state == SHIFT) begin
            shift_count <= shift_count + 1;
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            IDLE: begin
                if (pattern_reg == 4'b1101) begin
                    next_state = SHIFT;
                end else begin
                    next_state = IDLE;
                end
            end
            SHIFT: begin
                if (shift_count == 2'b11) begin  // After 4 cycles
                    next_state = COUNTING;
                end else begin
                    next_state = SHIFT;
                end
            end
            COUNTING: begin
                if (done_counting) begin
                    next_state = DONE;
                end else begin
                    next_state = COUNTING;
                end
            end
            DONE: begin
                if (ack) begin
                    next_state = IDLE;
                end else begin
                    next_state = DONE;
                end
            end
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    always @(*) begin
        shift_ena = 1'b0;
        counting = 1'b0;
        done = 1'b0;

        case (current_state)
            SHIFT:    shift_ena = 1'b1;
            COUNTING: counting = 1'b1;
            DONE:     done = 1'b1;
            default: ;  // Keep all outputs 0
        endcase
    end

endmodule