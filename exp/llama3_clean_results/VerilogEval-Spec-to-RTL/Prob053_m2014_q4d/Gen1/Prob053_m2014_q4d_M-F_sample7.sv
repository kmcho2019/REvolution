module TopModule(
    input clk,
    input in,
    output reg out
);

reg out_next; // Intermediate variable to hold the next value of 'out'

always @(*) begin
    out_next = in ^ out; // Calculate the next value of 'out' based on 'in' and current 'out'
end

always @(posedge clk) begin
    out <= out_next; // Update 'out' with the calculated next value at the positive edge of 'clk'
end

endmodule