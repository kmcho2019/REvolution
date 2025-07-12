module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [3:0] shift_reg;
reg start_shifting_reg;

assign start_shifting = start_shifting_reg;

always @(posedge clk) begin
    if (reset) begin
        shift_reg <= 4'b0000;
        start_shifting_reg <= 0;
    end else begin
        shift_reg <= {shift_reg[2:0], data};
        if (shift_reg == 4'b1101 && !start_shifting_reg) begin
            start_shifting_reg <= 1;
        end
    end
end

endmodule