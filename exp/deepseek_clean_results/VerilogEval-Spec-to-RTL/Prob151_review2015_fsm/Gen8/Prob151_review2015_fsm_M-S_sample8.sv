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
    
    reg [1:0] state;
    reg [3:0] shift_reg;

    // State transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 0;
        end else begin
            case (state)
                IDLE: begin
                    shift_reg <= {shift_reg[2:0], data};
                    if (shift_reg == 4'b1101) begin
                        state <= SHIFT;
                        shift_reg <= 0;
                    end
                end

                SHIFT: begin
                    shift_reg <= shift_reg + 1;
                    if (shift_reg == 3)  // After 4 cycles (0-3)
                        state <= COUNT;
                end

                COUNT: begin
                    if (done_counting && ack)
                        state <= IDLE;
                end
            endcase
        end
    end

    // Output assignments
    assign shift_ena = (state == SHIFT);
    assign counting = (state == COUNT);
    assign done = (state == COUNT) && done_counting;

endmodule