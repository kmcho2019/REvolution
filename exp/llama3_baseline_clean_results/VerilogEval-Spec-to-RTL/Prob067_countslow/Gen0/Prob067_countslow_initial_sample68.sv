module TopModule(
    input clk,
    input reset,
    input slowena,
    output [3:0] q
);

reg [3:0] q;

always @(posedge clk) begin
    if (reset) begin
        q <= 4'd0;
    end else if (slowena && (q < 4'd9)) begin
        q <= q + 1;
    end else if (slowena && (q == 4'd9)) begin
        q <= 4'd0;
    end
end

endmodule