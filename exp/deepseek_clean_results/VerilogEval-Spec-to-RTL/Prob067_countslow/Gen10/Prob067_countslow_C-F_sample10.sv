module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'd0;
    end
    else if (slowena) begin
        q <= (q == 4'd9) ? 4'd0 : q + 1'd1;
    end
end

endmodule