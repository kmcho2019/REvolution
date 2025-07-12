module TopModule (
    input clk,
    input areset,
    input [7:0] d,
    output [7:0] q
);

genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : dff_gen
        dff_async_reset dff_inst (
            .clk(clk),
            .reset(areset),
            .d(d[i]),
            .q(q[i])
        );
    end
endgenerate

endmodule

module dff_async_reset (
    input clk,
    input reset,
    input d,
    output reg q
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        q <= 1'b0;
    end else begin
        q <= d;
    end
end

endmodule