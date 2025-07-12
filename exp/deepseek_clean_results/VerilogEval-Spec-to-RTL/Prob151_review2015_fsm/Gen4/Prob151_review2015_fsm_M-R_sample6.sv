module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

    // State encoding
    localparam [1:0]
        S_IDLE    = 2'b00,
        S_SHIFT   = 2'b01,
        S_COUNT   = 2'b10,
        S_DONE    = 2'b11;

    reg [1:0] state;
    reg [1:0] shift_counter;
    reg [3:0] pattern_shift;
    wire pattern_match;

    // Pattern detection
    assign pattern_match = (pattern_shift == 4'b1101);

    always @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE;
            pattern_shift <= 4'b0;
            shift_counter <= 2'b0;
            shift_ena <= 1'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            // Default outputs
            shift_ena <= 1'b0;
            counting <= 1'b0;
            done <= 1'b0;

            case (state)
                S_IDLE: begin
                    pattern_shift <= {pattern_shift[2:0], data};
                    if (pattern_match) begin
                        state <= S_SHIFT;
                        shift_counter <= 2'b11; // Count 4 cycles (3 downto 0)
                    end
                end

                S_SHIFT: begin
                    shift_ena <= 1'b1;
                    if (shift_counter == 2'b0) begin
                        state <= S_COUNT;
                    end else begin
                        shift_counter <= shift_counter - 1;
                    end
                end

                S_COUNT: begin
                    counting <= 1'b1;
                    if (done_counting) begin
                        state <= S_DONE;
                    end
                end

                S_DONE: begin
                    done <= 1'b1;
                    if (ack) begin
                        state <= S_IDLE;
                        pattern_shift <= 4'b0;
                    end
                end
            endcase
        end
    end

endmodule