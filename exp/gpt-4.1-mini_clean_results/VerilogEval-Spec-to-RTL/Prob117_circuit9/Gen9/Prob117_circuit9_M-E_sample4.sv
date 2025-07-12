module TopModule (
    input        clk,
    input        a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a) begin
        q <= 3'd4; // Force q=4 when a=1
    end else begin
        // Increment q modulo 7 (values 0..6)
        // Wrap from 6 back to 0
        if (q == 3'd6)
            q <= 3'd0;
        else
            q <= q + 3'd1;
    end
end

endmodule