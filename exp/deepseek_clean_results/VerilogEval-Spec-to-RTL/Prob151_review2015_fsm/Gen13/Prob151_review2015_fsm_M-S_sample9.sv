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

    // Binary state encoding
    localparam IDLE     = 2'b00;
    localparam SHIFT    = 2'b01;
    localparam COUNTING = 2'b10;
    localparam DONE     = 2'b11;

    reg [1:0] state;
    reg [2:0] counter; // Counts both pattern bits and shift cycles

    // State transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            counter <= 3'b0;
        end else begin
            case (state)
                IDLE: begin
                    // Shift in data and check for pattern 1101
                    counter <= {counter[1:0], data};
                    if (counter[2:1] == 2'b11 && counter[0] == 1'b0 && data == 1'b1) begin
                        state <= SHIFT;
                        counter <= 3'b0; // Reset counter for shift phase
                    end
                end

                SHIFT: begin
                    counter <= counter + 1;
                    if (counter == 3'b011) // After 4 shifts (0-3)
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