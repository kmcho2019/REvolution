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

    // Simple binary state encoding
    localparam IDLE  = 2'b00;
    localparam SHIFT = 2'b01;
    localparam COUNT = 2'b10;
    localparam DONE  = 2'b11;

    reg [1:0] state, next_state;
    reg [3:0] pattern;
    reg [1:0] shift_cycles;

    // State transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern <= 4'b0;
            shift_cycles <= 2'b0;
        end else begin
            state <= next_state;
            
            // Pattern detection
            if (state == IDLE) begin
                pattern <= {pattern[2:0], data};
            end else begin
                pattern <= 4'b0;
            end
            
            // Shift cycle tracking
            if (state == SHIFT) begin
                shift_cycles <= shift_cycles + 1;
            end else begin
                shift_cycles <= 2'b0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE:  next_state = (pattern == 4'b1101) ? SHIFT : IDLE;
            SHIFT: next_state = (shift_cycles == 2'b11) ? COUNT : SHIFT;
            COUNT: next_state = done_counting ? DONE : COUNT;
            DONE:  next_state = ack ? IDLE : DONE;
            default: next_state = IDLE;
        endcase
    end

    // Output assignments
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == COUNT);
    assign done      = (state == DONE);

endmodule