module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a) begin
        q <= 3'd4;
    end else begin
        // Increment modulo 7 with the sequence starting at 4:
        // if q == 6, next is 0; if q == 3, next is 4; else increment by 1
        if (q == 3'd6)
            q <= 3'd0;
        else if (q == 3'd3)
            q <= 3'd4;
        else
            q <= q + 3'd1;
    end
end

endmodule