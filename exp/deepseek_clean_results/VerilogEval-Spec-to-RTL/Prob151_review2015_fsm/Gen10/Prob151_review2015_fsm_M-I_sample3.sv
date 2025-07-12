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

    // State encoding with descriptive names
    localparam S_IDLE      = 2'b00;  // Waiting for 1101 pattern
    localparam S_SHIFT     = 2'b01;  // Shifting in duration bits
    localparam S_COUNTING  = 2'b10;  // Waiting for counter to finish
    localparam S_DONE      = 2'b11;  // Timer done, waiting for ack

    reg [1:0] state;
    reg [1:0] shift_cnt;
    reg [3:0] pattern;

    // State transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE;
            shift_cnt <= 2'b0;
            pattern <= 4'b0;
        end else begin
            case (state)
                S_IDLE: begin
                    // Shift in new data and check for pattern
                    pattern <= {pattern[2:0], data};
                    if (pattern == 4'b1101) begin
                        state <= S_SHIFT;
                        shift_cnt <= 2'b0;  // Start counting from 0
                        pattern <= 4'b0;    // Clear pattern register
                    end
                end
                
                S_SHIFT: begin
                    if (shift_cnt == 2'b11)  // After 4 cycles (0-3)
                        state <= S_COUNTING;
                    else
                        shift_cnt <= shift_cnt + 1;
                end
                
                S_COUNTING: begin
                    if (done_counting)
                        state <= S_DONE;
                end
                
                S_DONE: begin
                    if (ack)
                        state <= S_IDLE;
                end
            endcase
        end
    end

    // Output assignments (pure combinational)
    assign shift_ena = (state == S_SHIFT);
    assign counting  = (state == S_COUNTING);
    assign done      = (state == S_DONE);

endmodule