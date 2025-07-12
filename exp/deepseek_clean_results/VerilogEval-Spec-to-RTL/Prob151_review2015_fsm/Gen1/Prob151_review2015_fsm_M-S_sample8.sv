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

    // FSM states
    localparam IDLE     = 2'b00;
    localparam SHIFT    = 2'b01;
    localparam COUNTING = 2'b10;
    localparam DONE     = 2'b11;

    reg [1:0] state;
    reg [3:0] pattern_reg;

    // State transitions and pattern detection
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
        end else begin
            case (state)
                IDLE: begin
                    pattern_reg <= {pattern_reg[2:0], data};
                    if (pattern_reg == 4'b1101) begin
                        state <= SHIFT;
                        pattern_reg <= 4'b0;  // Reset for shift counting
                    end
                end
                SHIFT: begin
                    pattern_reg <= {pattern_reg[2:0], 1'b0};  // Just count shifts
                    if (&pattern_reg[1:0]) begin  // After 4 shifts (counts 0-3)
                        state <= COUNTING;
                    end
                end
                COUNTING: begin
                    if (done_counting) begin
                        state <= DONE;
                    end
                end
                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

    // Output assignments
    always @(*) begin
        shift_ena = (state == SHIFT);
        counting = (state == COUNTING);
        done = (state == DONE);
    end

endmodule