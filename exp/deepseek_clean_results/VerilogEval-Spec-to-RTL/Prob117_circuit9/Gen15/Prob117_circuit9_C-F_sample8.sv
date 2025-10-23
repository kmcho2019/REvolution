module TopModule (
    input clk,
    input a,
    output reg [2:0] q = 3'b100  // Initialize to 4
);

wire clk_en = ~a | (q != 3'b100);  // Clock enable: only when q needs to change
wire clk_gated = clk & clk_en;

always @(posedge clk_gated) begin
    if (a) begin
        q <= 3'b100;  // Reset to 4 when a is high
    end else begin
        q <= (q == 3'b110) ? 3'b000 : q + 1'b1;  // Increment with wrap-around
    end
end

endmodule