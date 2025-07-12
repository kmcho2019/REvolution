module TopModule(
    input  clk,
    input  reset,
    output shift_ena
);

reg [1:0] count;
reg shift_ena_reg;

always @(posedge clk) begin
    if (reset) begin
        shift_ena_reg <= 1'b1;
        count <= 2'd0;
    end else if (count < 4) begin
        count <= count + 1;
        if (count == 4) begin
            shift_ena_reg <= 1'b0;
        end
    end
end

assign shift_ena = shift_ena_reg;

endmodule