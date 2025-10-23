// TopModule with 8 D Flip-Flops
module TopModule(
    input           clk,
    input           areset,
    input   [7:0]   d,
    output  [7:0]   q
);

    // Directly implement 8 D flip-flops within TopModule
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            q <= 8'b0;
        end else begin
            q <= d;
        end
    end

endmodule