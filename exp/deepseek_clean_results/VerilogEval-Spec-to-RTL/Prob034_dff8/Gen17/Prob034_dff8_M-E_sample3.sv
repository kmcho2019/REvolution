module TopModule (
    input clk,
    input [7:0] d,
    output [7:0] q
);

genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : dff_gen
        reg q_bit;
        always @(posedge clk) begin
            q_bit <= d[i];
        end
        assign q[i] = q_bit;
    end
endgenerate

endmodule