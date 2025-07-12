module TopModule (
    input        clk,
    input        a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a) begin
        q <= 3'd4;
    end else begin
        // Increment modulo 7: if q==6 then next is 0, else q+1
        if (q == 3'd6)
            q <= 3'd0;
        else
            q <= q + 3'd1;
    end
end

endmodule