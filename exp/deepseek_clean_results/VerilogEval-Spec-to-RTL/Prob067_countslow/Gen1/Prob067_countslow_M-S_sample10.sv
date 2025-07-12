module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 0;
    end
    else if (slowena) begin
        q <= (q == 9) ? 0 : q + 1;
    end
end

endmodule