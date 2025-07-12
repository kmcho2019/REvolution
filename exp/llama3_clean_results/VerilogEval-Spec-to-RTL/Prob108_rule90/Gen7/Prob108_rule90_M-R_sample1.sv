module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg;

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        q_reg <= q;
    end
end

integer i;
generate
    for (i = 0; i < 512; i++) begin: gen_block
        wire left, center, right;
        assign left = (i == 0) ? 1'b0 : q[i-1];
        assign center = q[i];
        assign right = (i == 511) ? 1'b0 : q[i+1];
        assign q_reg[i] = left ^ right;
    end
endgenerate

assign q = q_reg;

endmodule