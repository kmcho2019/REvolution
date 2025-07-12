module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a) begin
        q <= 3'b100; // Force to 4 when a is high
    end else begin
        q <= (q == 3'b110) ? 3'b000 : (q + 1); // Increment 0-6, wrap around
    end
end

endmodule