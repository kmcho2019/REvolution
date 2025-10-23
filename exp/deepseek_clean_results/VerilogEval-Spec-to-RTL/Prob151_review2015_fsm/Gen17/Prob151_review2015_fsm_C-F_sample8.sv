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
    reg [1:0] counter; // 2-bit counter for both pattern and shift counting

    // State transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            counter <= 2'b0;
        end else begin
            case (state)
                IDLE: begin
                    // Shift in data and check for pattern 1101
                    counter <= {counter[0], data};
                    
                    // Check for pattern 1101 (counter tracks last 2 bits)
                    if (counter == 2'b11 && data == 1'b1) begin
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
                    if (ack)
                        state <= IDLE;
                end
            endcase
        end
    end

    // Output assignments
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == COUNTING);
    assign done      = (state == DONE);

endmodule