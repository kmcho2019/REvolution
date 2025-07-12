module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    reg [3:0] shift_reg;
    reg found;

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 4'b0;
            found <= 1'b0;
        end else if (!found) begin
            shift_reg <= {shift_reg[2:0], data};
            found <= (shift_reg == 4'b1101);
        end
    end

    assign start_shifting = found;

endmodule