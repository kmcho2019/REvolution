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

    // One-hot state encoding for better timing
    localparam IDLE     = 4'b0001;
    localparam SHIFT    = 4'b0010;
    localparam COUNTING = 4'b0100;
    localparam DONE     = 4'b1000;

    reg [3:0] state;
    reg [1:0] counter; // 2-bit counter (0-3)
    reg [2:0] pattern; // Shift register for pattern detection
    wire terminal_count;
    wire pattern_match;
    wire shift_enable;

    // Enable signals for power optimization
    assign shift_enable = (state == IDLE) || (state == SHIFT);
    assign terminal_count = (counter == 2'b11);

    // Pipelined pattern detection
    assign pattern_match = (pattern == 3'b110) && (data == 1'b1);

    // State transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            counter <= 2'b0;
            pattern <= 3'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (shift_enable) begin
                        pattern <= {pattern[1:0], data};
                    end
                    if (pattern_match) begin
                        state <= SHIFT;
                        counter <= 2'b0;
                    end
                end

                SHIFT: begin
                    counter <= counter + 1;
                    if (terminal_count) begin
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
                        pattern <= 3'b0;
                    end
                end
            endcase
        end
    end

    // Output assignments - direct from state bits for better timing
    assign shift_ena = state[1]; // SHIFT state
    assign counting  = state[2]; // COUNTING state
    assign done      = state[3]; // DONE state

endmodule