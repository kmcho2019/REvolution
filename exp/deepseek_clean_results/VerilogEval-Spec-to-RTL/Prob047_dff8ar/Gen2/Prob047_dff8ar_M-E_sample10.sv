module TopModule (
    input clk,
    input areset,
    input [7:0] d,
    output [7:0] q
);

genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : dff_array
        reg q_bit;
        always @(posedge clk or posedge areset) begin
            if (areset) begin
                q_bit <= 1'b0;
            end else begin
                q_bit <= d[i];
            end
        end
        assign q[i] = q_bit;
    end
endgenerate

endmodule