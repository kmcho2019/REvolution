module TopModule (
    input clk,
    input in,
    output out
);

    reg d_out;
    wire xor_out = in ^ d_out;
    reg intermediate_reg;

    always @(*) begin
        intermediate_reg = xor_out;
    end

    always @(posedge clk) begin
        d_out <= intermediate_reg;
    end

    assign out = d_out;

endmodule