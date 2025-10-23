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
    reg [3:0] pattern_reg;
    reg [1:0] shift_cycles;

    // State transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 0;
            shift_cycles <= 0;
        end else begin
            case (state)
                IDLE: begin
                    pattern_reg <= {pattern_reg[2:0], data};
                    if (pattern_reg == 4'b1101) begin
                        state <= SHIFT;
                        pattern_reg <= 0;  // Clear to prevent false detection
                    end
                end

                SHIFT: begin
                    if (shift_cycles == 3) begin
                        state <= COUNT;
                        shift_cycles <= 0;
                    end else begin
                        shift_cycles <= shift_cycles + 1;
                    end
                end

                COUNT: begin
                    if (done_counting) begin
                        state <= DONE;
                    end
                end

                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

    // Output assignments
    assign shift_ena = (state == SHIFT);
    assign counting = (state == COUNT);
    assign done = (state == DONE);

endmodule