module TopModule(
    input clk,
    input in,
    output reg out
);

// Use a temporary signal to avoid direct feedback into the combinatorial logic
reg temp_out;

always @(*) begin
    // Calculate the next state based on the current 'temp_out' and 'in'
    out = in ^ temp_out;
end

always @(posedge clk) begin
    // Update 'temp_out' with the calculated 'out' at the positive edge of clk
    temp_out <= out;
end

// Initialize 'temp_out' to a known state to avoid undefined behavior
initial begin
    temp_out = 1'b0;
end

endmodule