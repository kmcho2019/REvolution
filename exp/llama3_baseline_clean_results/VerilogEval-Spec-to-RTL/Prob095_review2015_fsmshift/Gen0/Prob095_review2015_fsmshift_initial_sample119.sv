module TopModule(
    input  clk,
    input  reset,
    output shift_ena
);

reg [1:0] counter;
reg shift_ena_reg;

always @(posedge clk) begin
    if (reset) begin
        shift_ena_reg <= 1'b1;
        counter <= 2'd0;
    end else if (counter < 4'd4) begin
        shift_ena_reg <= 1'b1;
        counter <= counter + 1'd1;
    end else begin
        shift_ena_reg <= 1'b0;
    end
end

assign shift_ena = shift_ena_reg;

endmodule