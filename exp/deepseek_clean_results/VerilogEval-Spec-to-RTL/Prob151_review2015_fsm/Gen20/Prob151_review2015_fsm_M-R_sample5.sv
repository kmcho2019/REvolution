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

    // Gray-coded state encoding
    localparam IDLE     = 2'b00;
    localparam SHIFT    = 2'b01;
    localparam COUNTING = 2'b11;
    localparam DONE     = 2'b10;

    reg [1:0] state;
    reg [1:0] shift_cnt;
    reg [3:0] pattern_reg;

    // Pattern detection (shift register)
    always @(posedge clk) begin
        if (reset) begin
            pattern_reg <= 4'b0;
        end else if (state == IDLE) begin
            pattern_reg <= {pattern_reg[2:0], data};
        end
    end

    // State machine
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_cnt <= 2'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (pattern_reg == 4'b1101) begin
                        state <= SHIFT;
                        shift_cnt <= 2'b0;
                    end
                end

                SHIFT: begin
                    if (shift_cnt == 2'b11) begin // Count 0-3
                        state <= COUNTING;
                    end else begin
                        shift_cnt <= shift_cnt + 1;
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
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == COUNTING);
    assign done      = (state == DONE);

endmodule