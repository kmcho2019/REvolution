module TopModule (
    input clk,
    input in,
    output reg out = 0  // Initialize to 0 for known simulation startup state
);

    always @(posedge clk) begin
        out <= in ^ out;
    end

endmodule