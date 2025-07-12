module TopModule (
    input clk,
    input [7:0] d,
    output [7:0] q,
    input reset_n  // Optional active-low reset
);

genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : dff_gen
        // Explicit DFF instantiation with reset
        always @(posedge clk or negedge reset_n) begin
            if (!reset_n)
                q[i] <= 1'b0;
            else
                q[i] <= d[i];
        end
    end
endgenerate

endmodule