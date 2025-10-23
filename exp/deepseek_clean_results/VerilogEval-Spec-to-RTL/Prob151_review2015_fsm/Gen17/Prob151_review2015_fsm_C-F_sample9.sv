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

    // Gray state encoding for reduced switching power
    localparam IDLE     = 2'b00;
    localparam SHIFT    = 2'b01;
    localparam COUNTING = 2'b11;
    localparam DONE     = 2'b10;

    reg [1:0] state;
    reg [1:0] counter; // 2-bit counter (0-3)
    reg [1:0] pattern; // Only need to track last 2 bits for 110 detection

    // State transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            counter <= 2'b0;
            pattern <= 2'b0;
        end else begin
            case (state)
                IDLE: begin
                    // Shift in data and check for pattern 1101
                    pattern <= {pattern[0], data};
                    if (pattern == 2'b11 && data == 1'b0) begin // 110 detected
                        state <= SHIFT;
                        counter <= 2'b0;
                    end
                end

                SHIFT: begin
                    counter <= counter + 1;
                    if (counter == 2'b11) // After 4 shifts (0-3)
                        state <= COUNTING;
                end

                COUNTING: begin
                    if (done_counting)
                        state <= DONE;
                end

                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                        pattern <= 2'b0;
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