module TopModule(
    input clk,
    input in,
    input rst_n, // Active low reset
    output reg out
);

// D flip-flop to update the 'out' signal
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset 'out' to 0 on active low reset
        out <= 1'b0;
    end else begin
        // Calculate the next state of 'out' using the XOR of 'in' and the current 'out'
        out <= in ^ out;
    end
end

endmodule