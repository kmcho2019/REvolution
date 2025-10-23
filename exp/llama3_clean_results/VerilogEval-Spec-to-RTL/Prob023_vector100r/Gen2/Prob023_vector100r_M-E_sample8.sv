module TopModule(
    input  clk,
    input  [99:0] in,
    output [99:0] out
);

    reg [99:0] shift_reg;

    initial begin
        shift_reg = 100'b0;
    end

    always @ (posedge clk) begin
        shift_reg = {in[0], shift_reg[99:1]};
    end

    assign out = shift_reg;

endmodule