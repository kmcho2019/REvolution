module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

wire count_9; // High when q == 9

assign count_9 = (q == 4'd9);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'd0;
    end else if (slowena) begin
        if (count_9)
            q <= 4'd0;
        else
            q <= q + 4'd1;
    end
end

endmodule