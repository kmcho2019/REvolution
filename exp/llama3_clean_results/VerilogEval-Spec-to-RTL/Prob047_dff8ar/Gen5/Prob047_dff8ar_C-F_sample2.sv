module DFF(
    input clk,
    input areset,
    input d,
    output reg q
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= 1'd0;
    end else begin
        q <= d;
    end
end

endmodule

module TopModule(
    input clk,
    input areset,
    input [7:0] d,
    output [7:0] q
);

genvar i;
generate
    for (i = 0; i < 8; i++) begin
        DFF dff(clk, areset, d[i], q[i]);
    end
endgenerate

endmodule