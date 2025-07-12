module TopModule (
    input clk,
    input areset,
    input [7:0] d,
    output [7:0] q
);

genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : dff_array
        // Instantiate individual D flip-flops
        always @(posedge clk or posedge areset) begin
            if (areset) begin
                q[i] <= 1'b0;
            end
            else begin
                q[i] <= d[i];
            end
        end
    end
endgenerate

endmodule