module TopModule(
    input clk,
    input in,
    output reg out
);

// Calculate the next state of the flip-flop and update it in a single always block
always @ (posedge clk) begin
    out <= in ^ out; // Directly calculate and update 'out' using non-blocking assignment
end

endmodule