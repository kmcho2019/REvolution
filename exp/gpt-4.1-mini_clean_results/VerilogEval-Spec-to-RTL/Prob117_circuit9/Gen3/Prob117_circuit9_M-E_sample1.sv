module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a)
        q <= 3'd4;           // force q = 4 when a=1
    else begin
        // increment q modulo 7 starting from 4
        if (q == 3'd6)
            q <= 3'd0;
        else if (q == 3'd4)
            q <= 3'd5;
        else
            q <= q + 3'd1;
    end
end

endmodule