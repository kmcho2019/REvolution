module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    reg [3:0] shift_reg;
    reg start_shifting_reg;

    // Shift register update
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 4'b0;
        end else if (!start_shifting_reg) begin
            shift_reg <= {shift_reg[2:0], data};
        end
    end

    // Pattern detection (combinational)
    wire pattern_match = (shift_reg == 4'b1101);

    // Output latch
    always @(posedge clk) begin
        if (reset) begin
            start_shifting_reg <= 1'b0;
        end else if (pattern_match) begin
            start_shifting_reg <= 1'b1;
        end
    end

    assign start_shifting = start_shifting_reg;

endmodule