module TopModule (
    input clk,
    input areset,
    input [7:0] d,
    output reg [7:0] q
);

localparam WIDTH = 8;

genvar i;
generate
    for (i = 0; i < WIDTH; i = i + 1) begin : dff_gen
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