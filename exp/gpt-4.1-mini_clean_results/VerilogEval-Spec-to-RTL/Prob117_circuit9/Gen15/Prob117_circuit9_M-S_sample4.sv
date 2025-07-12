module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a) begin
        q <= 3'd4;
    end else begin
        // Advance state modulo 7 through 0 to 6
        if (q >= 3'd6)
            q <= 3'd0;
        else if (q <= 3'd6)
            q <= q + 3'd1;
        else
            q <= 3'd4; // fallback if q invalid
    end
end

endmodule