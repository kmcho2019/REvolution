// DFF module: A single D flip-flop
module DFF(
    input clk,
    input d,
    output reg q
);

always @(posedge clk) begin
    q <= d;
end

endmodule

// TopModule: Instantiates 8 DFFs
module TopModule(
    input clk,
    input [7:0] d,
    output [7:0] q
);

// Instantiate 8 DFFs
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin
        DFF dff_i(
            .clk(clk),
            .d(d[i]),
            .q(q[i])
        );
    end
endgenerate

endmodule