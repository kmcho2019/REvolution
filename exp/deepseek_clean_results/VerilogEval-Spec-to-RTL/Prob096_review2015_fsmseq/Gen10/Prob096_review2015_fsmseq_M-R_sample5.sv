module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    reg [3:0] shift_reg;
    wire [3:0] next_shift = {shift_reg[2:0], data};
    wire pattern_match = (shift_reg == 4'b1101);

    // Shift register implementation
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 4'b0;
        end else begin
            shift_reg <= next_shift;
        end
    end

    // Output logic - latches high once pattern is found
    reg start_shifting_reg;
    always @(posedge clk) begin
        if (reset) begin
            start_shifting_reg <= 1'b0;
        end else if (pattern_match) begin
            start_shifting_reg <= 1'b1;
        end
    end

    assign start_shifting = start_shifting_reg;

endmodule