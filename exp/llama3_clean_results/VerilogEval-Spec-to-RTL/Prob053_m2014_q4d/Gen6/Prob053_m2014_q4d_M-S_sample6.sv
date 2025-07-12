module TopModule(
    input clk,
    input in,
    output reg out
);

// Calculate and update 'out' based on its current state and 'in'
always @ (posedge clk) begin
    out <= in ^ out; // Use non-blocking assignment to update 'out'
end

endmodule