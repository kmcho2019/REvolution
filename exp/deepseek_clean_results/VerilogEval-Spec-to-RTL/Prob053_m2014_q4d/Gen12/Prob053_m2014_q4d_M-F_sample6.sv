module TopModule (
    input clk,
    input in,
    output reg out
);

    initial begin
        out = 1'b0;  // Initialize flip-flop output to 0
    end

    always @(posedge clk) begin
        out <= in ^ out;
    end

endmodule