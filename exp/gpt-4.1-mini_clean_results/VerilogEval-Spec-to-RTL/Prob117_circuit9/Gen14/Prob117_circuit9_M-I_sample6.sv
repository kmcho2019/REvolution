module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

reg [2:0] next_q;

always @(*) begin
    if (a) begin
        next_q = 3'd4;
    end else begin
        // Increment q modulo 7 (states 0 to 6), with wrap-around from 6 back to 0
        // Since q can have values beyond 6 only when reset to 4, the cycle is controlled correctly
        if (q == 3'd6)
            next_q = 3'd0;
        else
            next_q = q + 3'd1;
    end
end

always @(posedge clk) begin
    if (q != next_q)
        q <= next_q;
end

endmodule