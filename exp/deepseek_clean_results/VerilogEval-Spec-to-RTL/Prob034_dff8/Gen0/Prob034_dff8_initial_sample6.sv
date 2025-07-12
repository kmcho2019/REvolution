module TopModule (
    input clk,
    input [7:0] d,
    output [7:0] q
);

    // Generate 8 D flip-flops
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : dff_gen
            // Instantiate a D flip-flop for each bit
            always @(posedge clk) begin
                q[i] <= d[i];
            end
        end
    endgenerate

endmodule