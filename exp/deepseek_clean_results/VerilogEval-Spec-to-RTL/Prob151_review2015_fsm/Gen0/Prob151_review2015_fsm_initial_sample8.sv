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

    // Define states
    localparam IDLE   = 2'b00;
    localparam SHIFT  = 2'b01;
    localparam COUNT  = 2'b10;
    localparam DONE   = 2'b11;

    reg [1:0] current_state, next_state;
    reg [3:0] pattern_reg;
    reg [1:0] shift_count;

    // State register
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            pattern_reg <= 4'b0;
            shift_count <= 2'b0;
        end else begin
            current_state <= next_state;
            
            // Shift register for pattern detection
            pattern_reg <= {pattern_reg[2:0], data};
            
            // Shift counter
            if (current_state == SHIFT) begin
                shift_count <= shift_count + 1;
            end else begin
                shift_count <= 2'b0;
            end
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
                if (shift_count == 2'b11) begin  // After 4 cycles (0-3)
                    next_state = COUNT;
                end else begin
                    next_state = SHIFT;
                end
            end
            COUNT: begin
                if (done_counting) begin
                    next_state = DONE;
                end else begin
                    next_state = COUNT;
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
        shift_ena = (current_state == SHIFT);
        counting  = (current_state == COUNT);
        done      = (current_state == DONE);
    end

endmodule