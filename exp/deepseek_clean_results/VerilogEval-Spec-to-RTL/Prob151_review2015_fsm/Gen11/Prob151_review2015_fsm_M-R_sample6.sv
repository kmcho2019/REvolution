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

    reg [1:0] current_state, next_state;
    reg [3:0] shift_reg;
    reg [1:0] shift_count;

    // Pattern detection
    wire pattern_detected = (shift_reg == 4'b1101);

    // State transition logic
    always @(*) begin
        case (current_state)
            IDLE: next_state = pattern_detected ? SHIFT : IDLE;
            SHIFT: next_state = (shift_count == 2'b11) ? COUNT : SHIFT;
            COUNT: next_state = done_counting ? DONE : COUNT;
            DONE: next_state = ack ? IDLE : DONE;
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            shift_reg <= 4'b0;
            shift_count <= 2'b0;
        end else begin
            current_state <= next_state;
            shift_reg <= {shift_reg[2:0], data};

            // Shift counter logic
            if (current_state == SHIFT) begin
                shift_count <= shift_count + 1'b1;
            end else begin
                shift_count <= 2'b0;
            end
        end
    end

    // Output assignments
    assign shift_ena = (current_state == SHIFT);
    assign counting = (current_state == COUNT);
    assign done = (current_state == DONE);

endmodule