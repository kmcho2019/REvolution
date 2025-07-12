module TopModule (
    input       clk,
    input       resetn,
    input       in,
    output      out
);

reg [3:0] shift_reg;

always_ff @(posedge clk) begin
    if (!resetn) begin
        for (int i = 0; i < 4; i++) begin
            shift_reg[i] <= 1'b0;
        end
    end else begin
        for (int i = 3; i > 0; i--) begin
            shift_reg[i] <= shift_reg[i-1];
        end
        shift_reg[0] <= in;
    end
end

assign out = shift_reg[3];

endmodule