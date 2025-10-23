module TopModule(
    input clk,
    input d,
    input r,
    output reg q = 0
);

always @(posedge clk) begin
    if (r) begin
        q <= 1'b0; // Explicitly setting to 0 for clarity
    end else begin
        q <= d; // The flip-flop's basic operation
    end
end

endmodule