module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    // State encoding
    typedef enum logic [2:0] {
        IDLE,
        COUNT_ONES,
        COUNT_TENS,
        COUNT_HUNDREDS,
        COUNT_THOUSANDS
    } state_t;

    state_t current_state, next_state;
    reg [3:0] ones, tens, hundreds, thousands;
    reg [2:0] ena_reg;

    // Output assignments
    assign q = {thousands, hundreds, tens, ones};
    assign ena = ena_reg;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            ones <= 4'b0;
            tens <= 4'b0;
            hundreds <= 4'b0;
            thousands <= 4'b0;
            ena_reg <= 3'b0;
        end else begin
            current_state <= next_state;
            ena_reg <= 3'b0;  // Default to no enables

            case (current_state)
                IDLE: begin
                    next_state <= COUNT_ONES;
                end

                COUNT_ONES: begin
                    if (ones == 4'd9) begin
                        ones <= 4'd0;
                        ena_reg[0] <= 1'b1;  // Enable tens
                        next_state <= COUNT_TENS;
                    end else begin
                        ones <= ones + 4'd1;
                        next_state <= COUNT_ONES;
                    end
                end

                COUNT_TENS: begin
                    if (tens == 4'd9) begin
                        tens <= 4'd0;
                        ena_reg[1] <= 1'b1;  // Enable hundreds
                        next_state <= COUNT_HUNDREDS;
                    end else begin
                        tens <= tens + 4'd1;
                        next_state <= COUNT_ONES;
                    end
                end

                COUNT_HUNDREDS: begin
                    if (hundreds == 4'd9) begin
                        hundreds <= 4'd0;
                        ena_reg[2] <= 1'b1;  // Enable thousands
                        next_state <= COUNT_THOUSANDS;
                    end else begin
                        hundreds <= hundreds + 4'd1;
                        next_state <= COUNT_ONES;
                    end
                end

                COUNT_THOUSANDS: begin
                    if (thousands == 4'd9) begin
                        thousands <= 4'd0;
                    end else begin
                        thousands <= thousands + 4'd1;
                    end
                    next_state <= COUNT_ONES;
                end

                default: next_state <= IDLE;
            endcase
        end
    end

endmodule