module TopModule #(
    parameter LENGTH = 4
)(
    input clk,
    input resetn,
    input in,
    output reg out
);

reg [LENGTH-1:0] shift_reg;

always @(posedge clk) begin
    if (!resetn) begin
        shift_reg <= {LENGTH{1'b0}};
    end else begin
        shift_reg <= {in, shift_reg[LENGTH-1:1]};
    end
end

assign out = shift_reg[0];

endmodule