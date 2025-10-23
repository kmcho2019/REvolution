module TopModule (
    input  clk,
    input  reset,
    output shift_ena
);

reg [1:0] counter;
reg shift_ena_reg;

always @(posedge clk) begin
    if (reset) begin
        counter <= 2'b00;
        shift_ena_reg <= 1'b1;
    end else if (counter == 2'b11) begin
        shift_ena_reg <= 1'b0;
    end else if (shift_ena_reg == 1'b1) begin
        counter <= counter + 1'b1;
    end
end

assign shift_ena = shift_ena_reg;

endmodule