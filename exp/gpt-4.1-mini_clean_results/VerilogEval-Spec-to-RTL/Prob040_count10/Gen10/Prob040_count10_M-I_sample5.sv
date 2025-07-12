module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset)
        q <= 4'd0;
    else begin
        // Clock enable active only if q != 9, so counting stops momentarily at wrap-around
        if (q == 4'd9)
            q <= 4'd0;
        else
            q <= q + 4'd1;
    end
end

endmodule