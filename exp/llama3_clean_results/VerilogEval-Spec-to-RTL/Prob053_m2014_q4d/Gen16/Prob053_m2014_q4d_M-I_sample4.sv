module TopModule(
    input clk,
    input in,
    output reg out
);

// Always block for both combinational and sequential logic
always @(posedge clk) begin
    out <= in ^ out; // Directly compute XOR and update out at the next clock edge
end

endmodule