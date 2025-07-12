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
    reg [1:0] counter; // Reduced to 2-bit counter (0-3)
    reg [2:0] pattern_reg; // Track pattern match progress

    // State transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            counter <= 2'b0;
            pattern_reg <= 3'b0;
        end else begin
            case (state)
                IDLE: begin
                    // Shift in data and track pattern match
                    pattern_reg <= {pattern_reg[1:0], data};
                    
                    // Check for pattern 1101
                    if (pattern_reg == 3'b110 && data == 1'b1) begin
                        state <= SHIFT;
                        counter <= 2'b0;
                    end
                end

                SHIFT: begin
                    if (counter != 2'b11) begin // Enable counter only when needed
                        counter <= counter + 1;
                    end
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
                        pattern_reg <= 3'b0;
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