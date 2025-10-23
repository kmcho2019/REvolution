module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output logic [7:0] q
);

genvar i;
generate
    for (i = 0; i < 8; i++) begin
        always_ff @(posedge clk) begin
            if (reset) begin
                q[i] <= 1'b0;
            end else begin
                q[i] <= d[i];
            end
        end
    end
endgenerate

endmodule