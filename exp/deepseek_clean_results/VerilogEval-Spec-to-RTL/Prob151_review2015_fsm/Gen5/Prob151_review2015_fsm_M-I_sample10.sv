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
    localparam S_IDLE   = 2'b00;
    localparam S_SHIFT  = 2'b01;
    localparam S_COUNT  = 2'b10;
    localparam S_DONE   = 2'b11;

    reg [1:0] state;
    reg [1:0] shift_cnt;
    reg [3:0] shift_reg;

    // State transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE;
            shift_cnt <= 2'b00;
            shift_reg <= 4'b0000;
        end else begin
            case (state)
                S_IDLE: begin
                    shift_reg <= {shift_reg[2:0], data};
                    if (shift_reg == 4'b1101) begin
                        state <= S_SHIFT;
                        shift_cnt <= 2'b00;
                    end
                end

                S_SHIFT: begin
                    shift_reg <= {shift_reg[2:0], data};  // Continue shifting
                    if (shift_cnt == 2'b11)               // After 4 cycles (0-3)
                        state <= S_COUNT;
                    else
                        shift_cnt <= shift_cnt + 1;
                end

                S_COUNT: begin
                    if (done_counting)
                        state <= S_DONE;
                end

                S_DONE: begin
                    if (ack) begin
                        state <= S_IDLE;
                        shift_reg <= 4'b0000;  // Clear shift register
                    end
                end
            endcase
        end
    end

    // Continuous output assignments
    assign shift_ena = (state == S_SHIFT);
    assign counting = (state == S_COUNT);
    assign done = (state == S_DONE);

endmodule