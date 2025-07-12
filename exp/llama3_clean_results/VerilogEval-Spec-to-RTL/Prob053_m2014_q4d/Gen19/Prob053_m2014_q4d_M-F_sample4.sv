module TopModule(
    input clk,
    input in,
    output reg out = 1'b0
);

    // Single always block with posedge clock trigger
    always @(posedge clk) begin
        // Perform XOR operation between 'in' and current 'out'
        out <= in ^ out;
    end

endmodule