module TopModule(
    input clk,
    input d,
    output reg q
);
// Using always_ff for better performance and synthesizability
always_ff @(posedge clk) begin
    q <= d; // Direct assignment for simplicity and synthesizability
end

endmodule