module TopModule (
    input clk,
    input reset,
    output shift_ena
);

reg [1:0] counter;
reg [0:0] shift_ena_reg;

always @(posedge clk) begin
    if (reset) begin
        counter <= 0;
        shift_ena_reg <= 1;
    end else if (counter < 4) begin
        counter <= counter + 1;
        shift_ena_reg <= 1;
    end else begin
        shift_ena_reg <= 0;
    end
end

assign shift_ena = shift_ena_reg;

endmodule