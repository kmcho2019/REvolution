// Single D flip-flop module
module DFF (
    input clk,
    input d,
    output reg q
);
always @(posedge clk) q <= d;
endmodule

// Top module with 8 instantiated DFFs
module TopModule (
    input clk,
    input [7:0] d,
    output [7:0] q
);

// Instantiate 8 DFFs
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : dff_gen
        DFF dff_inst (
            .clk(clk),
            .d(d[i]),
            .q(q[i])
        );
    end
endgenerate

endmodule