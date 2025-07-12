module TopModule(
    input clk,
    input d,
    output reg q
);
// Using the always_ff block is already a good practice for performance
// and for a basic D flip-flop, this implementation is minimal and straightforward.
always_ff @(posedge clk) begin
    q <= d; // Direct assignment for simplicity and synthesizability
end

endmodule