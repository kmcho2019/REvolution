// Simplified TopModule with generate block
module TopModule(
    input clk,
    input [7:0] d,
    output reg [7:0] q
);

// Use a generate block to instantiate 8 D flip-flops
genvar i;
generate
    for (i = 0; i < 8; i++) begin
        always @(posedge clk) begin
            q[i] <= d[i];
        end
    end
endgenerate

endmodule