module DFF_AR (
    input clk,
    input areset,
    input d,
    output reg q
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= 0;
    end
    else begin
        q <= d;
    end
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
        DFF_AR dff_inst (
            .clk(clk),
            .areset(areset),
            .d(d[i]),
            .q(q[i])
        );
    end
endgenerate

endmodule