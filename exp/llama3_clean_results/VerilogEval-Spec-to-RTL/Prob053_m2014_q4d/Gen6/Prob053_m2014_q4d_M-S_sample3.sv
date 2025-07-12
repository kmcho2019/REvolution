module TopModule(
    input clk,
    input in,
    output reg out = 0 // Initialize out to avoid undefined state
);

always @(posedge clk) begin
    out <= in ^ out; // Update the output of the flip-flop based on 'in' and current 'out'
end

endmodule