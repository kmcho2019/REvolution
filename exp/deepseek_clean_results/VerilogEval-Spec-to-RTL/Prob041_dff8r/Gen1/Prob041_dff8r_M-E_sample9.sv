module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : dff_gen
        reg dff;
        always @(posedge clk) begin
            if (reset) begin
                dff <= 1'b0;
            end
            else begin
                dff <= d[i];
            end
        end
        assign q[i] = dff;
    end
endgenerate

endmodule