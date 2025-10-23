module TopModule (
    input clk,
    input in,
    output reg out
);

    initial begin
        out = 1'b0; // Initialize output to 0 to avoid unknown starting state
    end

    always @(posedge clk) begin
        out <= in ^ out;
    end

endmodule