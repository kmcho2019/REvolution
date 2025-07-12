// Novel TopModule using parametrized D flip-flops
module TopModule #(
    parameter WIDTH = 8
)(
    input clk,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);

// Generate WIDTH D flip-flops
genvar i;
generate
    for (i = 0; i < WIDTH; i++) begin
        always_ff @(posedge clk) begin
            q[i] <= d[i];
        end
    end
endgenerate

endmodule