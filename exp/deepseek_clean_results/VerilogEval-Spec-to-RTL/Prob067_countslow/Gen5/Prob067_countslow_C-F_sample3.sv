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
        q <= (q[3] & q[0]) ? 4'd0 : q + 1'b1;
    end
end

endmodule