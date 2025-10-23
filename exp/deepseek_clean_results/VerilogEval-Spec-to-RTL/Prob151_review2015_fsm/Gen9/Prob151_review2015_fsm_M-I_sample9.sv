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
    localparam IDLE    = 2'b00;
    localparam SHIFT   = 2'b01;
    localparam COUNT   = 2'b10;
    localparam DONE    = 2'b11;

    reg [1:0] state;
    reg [3:0] pattern_reg;  // For 1101 detection
    reg [1:0] shift_count;  // Counts 0-3 for 4 cycles

    // State transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            shift_count <= 2'b0;
        end else begin
            case (state)
                IDLE: begin
                    pattern_reg <= {pattern_reg[2:0], data};
                    if (pattern_reg == 4'b1101) begin
                        state <= SHIFT;
                        shift_count <= 2'b0;
                    end
                end
                SHIFT: begin
                    shift_count <= shift_count + 1;
                    if (shift_count == 2'b11)  // After 4 cycles
                        state <= COUNT;
                end
                COUNT: if (done_counting)
                    state <= DONE;
                DONE: if (ack) begin
                    state <= IDLE;
                    pattern_reg <= 4'b0;
                end
            endcase
        end
    end

    // Output assignments
    assign shift_ena = (state == SHIFT);
    assign counting = (state == COUNT);
    assign done = (state == DONE);

endmodule