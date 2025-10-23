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
    localparam COUNT_DONE = 2'b10;

    reg [1:0] state;
    reg [3:0] pattern_reg;  // Shift register for pattern detection
    reg [1:0] shift_count;  // Counts 4 shift cycles

    // Shift register and counter updates
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            shift_count <= 2'b0;
        end else begin
            // Always shift in new data
            pattern_reg <= {pattern_reg[2:0], data};

            case (state)
                IDLE: begin
                    if (pattern_reg == 4'b1101) begin
                        state <= SHIFT;
                        shift_count <= 2'b0;
                    end
                end

                SHIFT: begin
                    shift_count <= shift_count + 1;
                    if (shift_count == 2'b11)  // After 4 shifts
                        state <= COUNT_DONE;
                end

                COUNT_DONE: begin
                    if (done_counting && ack)
                        state <= IDLE;
                end
            endcase
        end
    end

    // Output logic
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == COUNT_DONE) && !done_counting;
    assign done      = (state == COUNT_DONE) && done_counting;

endmodule