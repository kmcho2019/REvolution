// TopModule with 8 D Flip-Flops
module TopModule(
    input           clk,
    input           areset,
    input   [7:0]   d,
    output reg [7:0] q
);

    integer i;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            for (i = 0; i < 8; i++) begin
                q[i] <= 1'b0;
            end
        end else begin
            for (i = 0; i < 8; i++) begin
                q[i] <= d[i];
            end
        end
    end

endmodule