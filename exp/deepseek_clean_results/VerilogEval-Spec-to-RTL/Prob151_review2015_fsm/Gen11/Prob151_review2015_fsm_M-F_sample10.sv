module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output shift_ena,
    output counting,
    output done
);

    // State encoding
    localparam IDLE  = 2'b00;
    localparam SHIFT = 2'b01;
    localparam COUNT = 2'b10;
    localparam DONE  = 2'b11;

    reg [1:0] state, next_state;
    reg [3:0] pattern_reg;
    reg [2:0] shift_count;  // Increased to 3 bits for counting 4 cycles

    // Pattern shift register
    always @(posedge clk) begin
        if (reset) begin
            pattern_reg <= 4'b0;
        end else begin
            pattern_reg <= {pattern_reg[2:0], data};
        end
    end

    // State and counter update
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_count <= 3'b0;
        end else begin
            state <= next_state;
            if (state == SHIFT) begin
                shift_count <= shift_count + 1'b1;
            end else begin
                shift_count <= 3'b0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE:  next_state = (pattern_reg == 4'b1101) ? SHIFT : IDLE;
            SHIFT: next_state = (shift_count == 3'd3) ? COUNT : SHIFT;  // 4 cycles (0-3)
            COUNT: next_state = done_counting ? DONE : COUNT;
            DONE:  next_state = ack ? IDLE : DONE;
            default: next_state = IDLE;
        endcase
    end

    // Output assignments
    assign shift_ena = (state == SHIFT);
    assign counting = (state == COUNT);
    assign done = (state == DONE);

endmodule