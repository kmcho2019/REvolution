module TopModule(
    input clk,
    input a,
    output reg [2:0] q = 4 // Initialize 'q' to 4 directly in the declaration
);

always @ (posedge clk) begin
    if (a) begin
        q <= 4; // Reset to 4 when 'a' is 1
    end else begin
        q <= (q + 1) % 8; // Increment 'q' and wrap around to 0 when 'q' reaches 7
    end
end

endmodule