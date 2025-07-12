// Instantiate the DFFs directly within the TopModule
module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output logic [7:0] q
);

    // Use a generate block to instantiate the DFFs
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin
            always_ff @(posedge clk) begin
                if (reset) q[i] <= 0;
                else q[i] <= d[i];
            end
        end
    endgenerate

endmodule