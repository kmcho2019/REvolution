module TopModule (
    input clk,
    input in,
    output reg out
);

    // Initialize out to 0 to avoid unknown start-up state
    initial begin
        out = 1'b0;
    end

    always @(posedge clk) begin
        out <= in ^ out;
    end

endmodule