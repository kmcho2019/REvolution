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

    // Pattern detection shift register
    reg [3:0] pattern_shift_reg;

    always @(posedge clk) begin
        if (reset)
            pattern_shift_reg <= 4'b0000;
        else
            pattern_shift_reg <= {pattern_shift_reg[2:0], data};
    end

    // Pattern matched when shift register == 4'b1101
    wire pattern_matched = (pattern_shift_reg == 4'b1101);

    // FSM States
    localparam IDLE  = 2'd0;
    localparam SHIFT = 2'd1;
    localparam COUNT = 2'd2;
    localparam DONE  = 2'd3;

    reg [1:0] state, next_state;
    reg [1:0] shift_count;

    // State register and shift counter
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_count <= 2'd0;
        end else begin
            state <= next_state;
            if (state == SHIFT)
                shift_count <= shift_count + 2'd1;
            else
                shift_count <= 2'd0;
        end
    end

    // Next state logic
    always @(*) begin
        case(state)
            IDLE:  next_state = pattern_matched ? SHIFT : IDLE;
            SHIFT: next_state = (shift_count == 2'd3) ? COUNT : SHIFT;
            COUNT: next_state = done_counting ? DONE : COUNT;
            DONE:  next_state = ack ? IDLE : DONE;
            default: next_state = IDLE;
        endcase
    end

    // Outputs assigned combinationally
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == COUNT);
    assign done      = (state == DONE);

endmodule