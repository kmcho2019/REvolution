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
    localparam IDLE         = 3'b000;
    localparam SHIFT        = 3'b001;
    localparam COUNTING     = 3'b010;
    localparam DONE         = 3'b011;
    localparam WAIT_ACK     = 3'b100;

    reg [2:0] state;
    reg [3:0] pattern_reg;  // For 1101 pattern detection
    reg [1:0] shift_count;  // Counts 4 shift cycles

    // Pattern detection shift register
    always @(posedge clk) begin
        if (reset) begin
            pattern_reg <= 4'b0;
        end else if (state == IDLE) begin
            pattern_reg <= {pattern_reg[2:0], data};
        end
    end

    // Shift counter
    always @(posedge clk) begin
        if (reset || state != SHIFT) begin
            shift_count <= 2'b0;
        end else begin
            shift_count <= shift_count + 1;
        end
    end

    // State transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (pattern_reg == 4'b1101) begin
                        state <= SHIFT;
                    end
                end

                SHIFT: begin
                    if (shift_count == 2'b11) begin  // After 4 cycles
                        state <= COUNTING;
                    end
                end

                COUNTING: begin
                    if (done_counting) begin
                        state <= DONE;
                    end
                end

                DONE: begin
                    state <= WAIT_ACK;
                end

                WAIT_ACK: begin
                    if (ack) begin
                        state <= IDLE;
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end

    // Output assignments
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == COUNTING);
    assign done      = (state == DONE) || (state == WAIT_ACK);

endmodule