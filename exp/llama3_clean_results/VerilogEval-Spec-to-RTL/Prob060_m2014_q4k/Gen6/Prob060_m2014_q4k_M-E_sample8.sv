module TopModule(
    input clk,
    input resetn,
    input in,
    output reg out
);

reg [3:0] shift_reg;

always @(posedge clk) begin
    if (!resetn) begin
        shift_reg <= 4'b0000;
    end else begin
        shift_reg <= {in, shift_reg[3:1]};
        out <= shift_reg[0];
    end
end

endmodule