module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'd1;
    end else begin
        if (q == 4'd10)
            q <= 4'd1;
        else begin
            // BCD increment: only increment the units digit and carry over manually
            if (q[3:0] == 4'd9)
                q <= 4'd10;
            else
                q <= q + 4'd1;
        end
    end
end

endmodule