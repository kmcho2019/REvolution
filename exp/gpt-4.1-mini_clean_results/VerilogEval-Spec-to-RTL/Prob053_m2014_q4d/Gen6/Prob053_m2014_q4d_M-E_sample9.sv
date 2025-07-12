module TopModule (
    input clk,
    input in,
    output out
);

    reg out_reg;
    wire xor_out;

    assign xor_out = in ^ out_reg;
    assign out = out_reg;

    always @(posedge clk) begin
        out_reg <= xor_out;
    end

endmodule