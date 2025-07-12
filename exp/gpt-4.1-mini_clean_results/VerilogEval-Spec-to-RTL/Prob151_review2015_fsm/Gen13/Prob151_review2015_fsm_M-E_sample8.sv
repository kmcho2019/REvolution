module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire data,
    input  wire done_counting,
    input  wire ack,
    output wire shift_ena,
    output wire counting,
    output wire done
);

    // State encoding (binary)
    localparam IDLE  = 2'd0;
    localparam SHIFT = 2'd1;
    localparam COUNT = 2'd2;
    localparam DONE  = 2'd3;

    reg [1:0] state, next_state;
    reg [2:0] shift_count; // counts 0..3 for 4 cycles shift enable

    reg [3:0] pattern_shift_reg; // tracks last 4 bits input to detect pattern 1101

    // Shift pattern register on every clock, except in reset
    always @(posedge clk) begin
        if (reset) begin
            pattern_shift_reg <= 4'b0000;
        end else if (state == IDLE) begin
            // shift in new data for pattern detection in IDLE state only
            pattern_shift_reg <= {pattern_shift_reg[2:0], data};
        end
    end

    // State and shift_count registers with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_count <= 3'd0;
        end else begin
            state <= next_state;
            if (state == SHIFT)
                shift_count <= shift_count + 3'd1;
            else
                shift_count <= 3'd0;
        end
    end

    // Next-state logic
    always @(*) begin
        case (state)
            IDLE: begin
                // When detected pattern 1101 (binary 4'b1101) start shifting
                if (pattern_shift_reg == 4'b1101)
                    next_state = SHIFT;
                else
                    next_state = IDLE;
            end

            SHIFT: begin
                if (shift_count == 3'd3) // done shifting 4 bits (counts 0..3)
                    next_state = COUNT;
                else
                    next_state = SHIFT;
            end

            COUNT: begin
                if (done_counting)
                    next_state = DONE;
                else
                    next_state = COUNT;
            end

            DONE: begin
                if (ack)
                    next_state = IDLE;
                else
                    next_state = DONE;
            end

            default: next_state = IDLE;
        endcase
    end

    // Outputs
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == COUNT);
    assign done      = (state == DONE);

endmodule