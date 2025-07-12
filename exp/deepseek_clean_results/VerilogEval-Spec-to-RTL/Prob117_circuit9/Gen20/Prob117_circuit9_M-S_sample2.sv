module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a) begin
        q <= 3'b100;  // Force q=4 when a=1
    end else begin
        q <= (q == 3'b110) ? 3'b000 : q + 1;  // Increment and wrap around 0-6
    end
end

endmodule