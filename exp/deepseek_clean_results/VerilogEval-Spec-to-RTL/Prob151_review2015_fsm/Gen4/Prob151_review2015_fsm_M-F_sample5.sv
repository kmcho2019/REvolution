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
    localparam IDLE     = 2'b00;
    localparam SHIFT    = 2'b01;
    localparam COUNTING = 2'b10;
    localparam DONE     = 2'b11;

    reg [1:0] state;
    reg [1:0] shift_cnt;
    reg [3:0] pattern;

    // State transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_cnt <= 0;
            pattern <= 0;
        end else begin
            case (state)
                IDLE: begin
                    // Shift in new data and maintain last 3 bits
                    pattern <= {pattern[2:0], data};
                    
                    // Only check for pattern when we have 4 bits
                    if (&shift_cnt) begin  // shift_cnt == 2'b11 indicates we have 4 bits
                        if (pattern == 4'b1101) begin
                            state <= SHIFT;
                            shift_cnt <= 0;
                            pattern <= 0;  // Clear pattern when leaving IDLE
                        end
                    end else begin
                        shift_cnt <= shift_cnt + 1;
                    end
                end
                
                SHIFT: begin
                    shift_cnt <= shift_cnt + 1;
                    if (shift_cnt == 3) begin  // After 4 cycles (0-3)
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
                        shift_cnt <= 0;  // Reset shift counter for next pattern detection
                    end
                end
            endcase
        end
    end

    // Output assignments
    assign shift_ena = (state == SHIFT);
    assign counting = (state == COUNTING);
    assign done = (state == DONE);

endmodule