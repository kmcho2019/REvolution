module TopModule (
    input clk,
    input [7:0] d,
    output [7:0] q
);

// Explicit instantiation of 8 DFFs
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : dff_gen
        always @(posedge clk) begin
            q[i] <= d[i];
        end
    end
endgenerate

endmodule