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
    reg [1:0] shift_cnt;
    reg [3:0] pattern;

    // Continuous pattern detection
    always @(posedge clk) begin
        if (reset) begin
            pattern <= 4'b0;
        end else begin
            pattern <= {pattern[2:0], data};
        end
    end

    // State transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_cnt <= 2'b11; // Initialize to 3 (counts down)
        end else begin
            state <= next_state;
            
            if (state == SHIFT) begin
                shift_cnt <= shift_cnt - 1;
            end else if (state == IDLE) begin
                shift_cnt <= 2'b11; // Reset counter
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE:  next_state = (pattern == 4'b1101) ? SHIFT : IDLE;
            SHIFT: next_state = (shift_cnt == 0) ? COUNT : SHIFT;
            COUNT: next_state = done_counting ? DONE : COUNT;
            DONE:  next_state = ack ? IDLE : DONE;
            default: next_state = IDLE;
        endcase
    end

    // Output generation (combinational)
    assign shift_ena = (state == SHIFT);
    assign counting = (state == COUNT);
    assign done = (state == DONE);

endmodule