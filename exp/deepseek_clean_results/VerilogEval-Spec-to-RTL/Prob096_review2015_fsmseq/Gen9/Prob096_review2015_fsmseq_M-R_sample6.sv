module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    reg [3:0] shift_reg;
    wire pattern_found = (shift_reg == 4'b1101);

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 4'b0;
        end else if (!pattern_found) begin
            shift_reg <= {shift_reg[2:0], data};
        end
    end

    assign start_shifting = pattern_found;

endmodule