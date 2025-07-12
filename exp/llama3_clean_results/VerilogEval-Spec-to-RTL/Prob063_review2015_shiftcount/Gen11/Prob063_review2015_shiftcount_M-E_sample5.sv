module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] shift_reg = 4'b0;
reg [3:0] counter = 4'b0;

always @(posedge clk) begin
    if (shift_ena) begin
        shift_reg <= {data, shift_reg[3:1]};
    end else if (count_ena) begin
        if (counter == 4'b0) begin
            counter <= 4'b1111;  // Wrap around to maximum value
        end else begin
            counter <= counter - 1;
        end
        shift_reg <= counter;
    end
end

assign q = shift_reg;

endmodule