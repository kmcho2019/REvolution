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
    localparam IDLE  = 2'b00;
    localparam SHIFT = 2'b01;
    localparam COUNT = 2'b10;
    localparam DONE  = 2'b11;

    reg [1:0] state;
    reg [3:0] pattern_reg;
    reg [1:0] shift_counter;

    // State transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            shift_counter <= 2'b0;
        end else begin
            case (state)
                IDLE: begin
                    pattern_reg <= {pattern_reg[2:0], data};
                    if (pattern_reg == 4'b1101) begin
                        state <= SHIFT;
                        pattern_reg <= 4'b0;  // Clear to prevent false detection
                    end
                end
                SHIFT: begin
                    shift_counter <= shift_counter + 1;
                    if (shift_counter == 2'b11) begin
                        state <= COUNT;
                        shift_counter <= 2'b0;
                    end
                end
                COUNT: begin
                    if (done_counting) state <= DONE;
                end
                DONE: begin
                    if (ack) state <= IDLE;
                end
            endcase
        end
    end

    // Output logic
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == COUNT);
    assign done      = (state == DONE);

endmodule