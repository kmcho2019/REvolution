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
    localparam IDLE      = 2'b00;
    localparam SHIFT     = 2'b01;
    localparam COUNTING  = 2'b10;
    localparam DONE      = 2'b11;

    reg [1:0] state;
    reg [2:0] shift_cnt;  // Now 3 bits to count 4 cycles (0-3)
    reg [3:0] pattern;

    // State transitions and registers
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_cnt <= 3'b0;
            pattern <= 4'b0;
        end else begin
            case (state)
                IDLE: begin
                    pattern <= {pattern[2:0], data};
                    if (pattern == 4'b1101) begin
                        state <= SHIFT;
                        shift_cnt <= 3'b0;
                    end
                end

                SHIFT: begin
                    if (shift_cnt == 3'b011) begin  // Count to 3 (4 cycles)
                        state <= COUNTING;
                    end
                    shift_cnt <= shift_cnt + 1;
                end

                COUNTING: begin
                    if (done_counting) begin
                        state <= DONE;
                    end
                end

                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                        pattern <= 4'b0;  // Clear pattern for new detection
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