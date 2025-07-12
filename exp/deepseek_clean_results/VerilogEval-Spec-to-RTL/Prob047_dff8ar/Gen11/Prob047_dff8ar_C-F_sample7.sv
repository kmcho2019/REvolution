module DFF_AR (
    input clk,
    input areset,
    input d,
    output reg q
);

always @(posedge clk or posedge areset) begin
    q <= areset ? 1'b0 : d;
end

endmodule

module TopModule (
    input clk,
    input areset,
    input [7:0] d,
    output [7:0] q
);

genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : dff_array
        DFF_AR dff (
            .clk(clk),
            .areset(areset),
            .d(d[i]),
            .q(q[i])
        );
    end
endgenerate

endmodule