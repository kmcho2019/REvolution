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
    reg [2:0] pattern_reg;  // Stores last 3 bits
    reg [1:0] shift_count;  // Counts 0-3 (4 cycles)

    // State and pattern update
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 3'b0;
            shift_count <= 2'b0;
        end else begin
            state <= next_state;
            pattern_reg <= {pattern_reg[1:0], data};
            
            if (state == SHIFT) begin
                shift_count <= shift_count + 1'b1;
            end else begin
                shift_count <= 2'b0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;  // Default: stay in current state
        case (state)
            IDLE:  if ({pattern_reg, data} == 4'b1101) next_state = SHIFT;
            SHIFT: if (shift_count == 2'd3) next_state = COUNT;
            COUNT: if (done_counting) next_state = DONE;
            DONE:  if (ack) next_state = IDLE;
        endcase
    end

    // Output assignments
    assign shift_ena = (state == SHIFT);
    assign counting = (state == COUNT);
    assign done = (state == DONE);

endmodule