module TopModule (
    input clk,
    input areset,
    input [7:0] d,
    output [7:0] q
);

genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : dff_gen
        reg q_ff;
        
        always @(posedge clk or posedge areset) begin
            if (areset) begin
                q_ff <= 1'b0;
            end else begin
                q_ff <= d[i];
            end
        end
        
        assign q[i] = q_ff;
    end
endgenerate

endmodule