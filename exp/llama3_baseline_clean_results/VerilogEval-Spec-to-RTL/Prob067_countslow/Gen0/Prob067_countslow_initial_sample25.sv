module TopModule(
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000;  // Reset the counter to 0 when reset is high
    end else if (slowena) begin
        if (q == 4'd9) begin
            q <= 4'b0000;  // Wrap around to 0 when counter reaches 10
        end else begin
            q <= q + 1;  // Increment the counter when slowena is high
        end
    end
end

endmodule