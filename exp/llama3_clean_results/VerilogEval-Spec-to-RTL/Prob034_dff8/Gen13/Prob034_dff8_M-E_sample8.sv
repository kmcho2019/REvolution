// Define a basic D flip-flop module
module DFF(
    input clk,
    input d,
    output reg q
);

always @(posedge clk) begin
    q <= d;
end

endmodule

// TopModule with 8 D flip-flops
module TopModule(
    input clk,
    input [7:0] d,
    output [7:0] q
);

// Use a generate block to instantiate 8 DFFs
genvar i;
generate
    for (i = 0; i < 8; i++) begin
        DFF dff_inst(
            .clk(clk),
            .d(d[i]),
            .q(q[i])
        );
    end
endgenerate

endmodule