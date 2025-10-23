// Define a module for a single D flip-flop
module DFF(
    input clk,
    input d,
    output reg q = 0
);

always_ff @(posedge clk) begin
    q <= d;
end

endmodule

// Define the TopModule that includes 8 D flip-flops
module TopModule(
    input clk,
    input [7:0] d,
    output [7:0] q
);

// Instantiate 8 DFFs
genvar i;
generate
    for (i = 0; i < 8; i++) begin
        DFF dff(
           .clk(clk),
           .d(d[i]),
           .q(q[i])
        );
    end
endgenerate

endmodule