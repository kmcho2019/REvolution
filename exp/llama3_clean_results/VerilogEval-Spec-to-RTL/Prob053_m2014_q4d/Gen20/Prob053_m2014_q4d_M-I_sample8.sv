module TopModule(
    input clk,
    input in,
    output reg out
);

    // Initial block to set 'out' after the first clock edge
    initial begin
        out = 1'b0;
    end

    // Single always block with posedge clock trigger
    always @(posedge clk) begin
        // Perform XOR operation between 'in' and current 'out'
        out <= in ^ out;
    end

endmodule