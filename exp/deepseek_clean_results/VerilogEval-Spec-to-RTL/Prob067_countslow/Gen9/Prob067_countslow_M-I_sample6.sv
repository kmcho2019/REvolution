module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

reg overflow;

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000;
        overflow <= 1'b0;
    end
    else if (slowena) begin
        overflow <= (q == 4'b1001);  // Detect overflow one cycle early
        q <= overflow ? 4'b0000 : q + 1'b1;
    end
end

endmodule