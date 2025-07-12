module TopModule (
    input clk,
    input in,
    output reg out
);

    initial begin
        out = 1'b0;  // Initialize output to zero for simulation consistency
    end

    always @(posedge clk) begin
        out <= in ^ out;
    end

endmodule