module TopModule(
    input clk,
    input d,
    output reg q
);
// Using always block with posedge clk trigger for sequential logic
always @(posedge clk) begin
    q <= d; // Direct assignment for simplicity and synthesizability
end

endmodule