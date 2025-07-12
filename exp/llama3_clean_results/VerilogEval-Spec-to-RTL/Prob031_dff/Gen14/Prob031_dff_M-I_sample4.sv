module TopModule(
    input clk,
    input d,
    output reg q
);
// Internal signal to gate the clock
reg clk_gated;

// Gate the clock when d equals q
always @(posedge clk) begin
    if (d!= q) begin
        clk_gated <= 1'b1;
    end else begin
        clk_gated <= 1'b0;
    end
end

// Using always_ff for better performance and synthesizability
always_ff @(posedge clk_gated or negedge clk_gated) begin
    if (clk_gated) begin
        q <= d; // Direct assignment for simplicity and synthesizability
    end
end

endmodule