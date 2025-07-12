module TopModule(
    input clk,
    input d,
    output reg q = 0 // Initialize output to 0 for simulation and synthesis purposes
);

always @(clk or d) begin
    if (clk) begin
        q <= d; // Update output when clock is high
    end else begin
        q <= q; // Hold current state when clock is low
    end
end

endmodule