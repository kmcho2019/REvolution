module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'd0;
    end else if (slowena) begin
        q <= (q == 4'd9) ? 4'd0 : q + 4'd1;
    end
    // else hold q, no change to minimize toggling
end

endmodule