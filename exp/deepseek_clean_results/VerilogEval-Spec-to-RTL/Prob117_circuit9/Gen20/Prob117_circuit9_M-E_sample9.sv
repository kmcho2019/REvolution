module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a) begin
        q <= 3'd4;  // Freeze at 4 when a is high
    end else begin
        // Count up normally, wrapping after 6
        if (q == 3'd6)
            q <= 3'd0;
        else
            q <= q + 1;
    end
end

endmodule