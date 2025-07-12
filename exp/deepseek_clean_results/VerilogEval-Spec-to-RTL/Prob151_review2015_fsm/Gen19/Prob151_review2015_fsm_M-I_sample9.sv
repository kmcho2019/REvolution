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

    // Gray-coded state encoding for reduced switching power
    localparam IDLE     = 2'b00;
    localparam SHIFT    = 2'b01;
    localparam COUNTING = 2'b11;
    localparam DONE     = 2'b10;

    reg [1:0] state;
    reg [1:0] counter; // Now 2-bit counter (counts 0-3)
    reg [2:0] pattern; // Tracks pattern match progress

    // State transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            counter <= 2'b0;
            pattern <= 3'b0;
        end else begin
            case (state)
                IDLE: begin
                    // Shift in data and track pattern match
                    pattern <= {pattern[1:0], data};
                    
                    // Check for pattern 1101 (stored as 1011 in pattern reg)
                    if (pattern == 3'b101) begin
                        if (data == 1'b1) begin
                            state <= SHIFT;
                            counter <= 2'b0;
                        end
                    end
                end

                SHIFT: begin
                    if (!counter[1]) begin // Only count when needed
                        counter <= counter + 1;
                    end
                    if (counter[1]) begin // Check MSB for completion (counter == 3)
                        state <= COUNTING;
                    end
                end

                COUNTING: begin
                    if (done_counting)
                        state <= DONE;
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

    // Output assignments
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == COUNTING);
    assign done      = (state == DONE);

endmodule