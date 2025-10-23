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

    // One-hot state encoding
    parameter IDLE     = 4'b0001;
    parameter SHIFT    = 4'b0010;
    parameter COUNTING = 4'b0100;
    parameter DONE     = 4'b1000;

    reg [3:0] state;
    reg [3:0] pattern;
    reg [2:0] shift_ctr;  // Now 3 bits for 4 cycles

    // Continuous pattern detection
    wire pattern_match = (pattern == 4'b1101);

    // State transitions and control logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern <= 4'b0;
            shift_ctr <= 3'b0;
        end else begin
            case (state)
                IDLE: begin
                    pattern <= {pattern[2:0], data};
                    if (pattern_match) begin
                        state <= SHIFT;
                        shift_ctr <= 3'b0;
                    end
                end
                
                SHIFT: begin
                    shift_ctr <= shift_ctr + 1;
                    if (shift_ctr == 3'b011) begin  // After 4 cycles
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
                        pattern <= 4'b0;
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