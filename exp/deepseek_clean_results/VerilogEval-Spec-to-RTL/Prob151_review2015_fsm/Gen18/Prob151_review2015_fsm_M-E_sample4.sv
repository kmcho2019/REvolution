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

    // State encoding with explicit state durations
    localparam IDLE   = 3'b000;
    localparam SHIFT  = 3'b001;
    localparam COUNT  = 3'b010;
    localparam DONE   = 3'b100;

    reg [2:0] state;
    reg [3:0] pattern_reg;
    reg [1:0] state_timer;

    // Parallel pattern detection
    always @(posedge clk) begin
        if (reset) begin
            pattern_reg <= 4'b0;
        end else begin
            pattern_reg <= {pattern_reg[2:0], data};
        end
    end

    // State duration timer (counts 0-3 for SHIFT state)
    always @(posedge clk) begin
        if (reset || (state != SHIFT)) begin
            state_timer <= 2'b0;
        end else begin
            state_timer <= state_timer + 1'b1;
        end
    end

    // State transitions with explicit timing
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE:  state <= (pattern_reg == 4'b1101) ? SHIFT : IDLE;
                SHIFT: state <= (state_timer == 2'b11) ? COUNT : SHIFT;
                COUNT: state <= done_counting ? DONE : COUNT;
                DONE:  state <= ack ? IDLE : DONE;
                default: state <= IDLE;
            endcase
        end
    end

    // Output assignments with glitch protection
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == COUNT);
    assign done      = (state == DONE);

endmodule