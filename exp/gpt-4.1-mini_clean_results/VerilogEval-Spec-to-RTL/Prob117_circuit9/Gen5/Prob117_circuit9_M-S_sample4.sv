module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a) begin
        q <= 3'd4;
    end else begin
        // If q is invalid (>6), reset to 4
        if (q > 3'd6)
            q <= 3'd4;
        else
            q <= (q == 3'd6) ? 3'd0 : q + 3'd1;
    end
end

endmodule