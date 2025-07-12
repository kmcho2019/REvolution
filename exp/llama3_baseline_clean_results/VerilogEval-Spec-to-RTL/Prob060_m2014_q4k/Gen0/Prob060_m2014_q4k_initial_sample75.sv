module TopModule (
    input  logic clk,
    input  logic resetn,
    input  logic in,
    output logic out
);

logic [3:0] shift_reg;

always_ff @(posedge clk) begin
    if (!resetn) begin
        shift_reg <= 4'b0000;
    end else begin
        shift_reg <= {in, shift_reg[3:1]};
    end
end

assign out = shift_reg[0];

endmodule