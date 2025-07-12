module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000;
    end
    else if (slowena) begin
        q <= (q == 4'b1001) ? 4'b0000 : q + 1'b1;
    end
    // Implicit else maintains q when slowena is low
end

endmodule