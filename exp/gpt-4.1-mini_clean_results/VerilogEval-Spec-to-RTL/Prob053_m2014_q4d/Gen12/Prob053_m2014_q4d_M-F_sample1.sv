module TopModule (
    input clk,
    input in,
    output reg out
);

    // Initialize output to 0 at simulation start to avoid unknown states
    initial begin
        out = 0;
    end

    // D flip-flop updates output at posedge clk with XOR of in and current out
    always @(posedge clk) begin
        out <= in ^ out;
    end

endmodule