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
        // If q out of range (7 or higher), reset to 4 to recover
        if (q > 3'd6)
            next_q = 3'd4;
        else if (q == 3'd6)
            next_q = 3'd0;  // modulo 7 wrap-around
        else
            next_q = q + 3'd1;
    end
end

always @(posedge clk) begin
    // Update only if next_q differs to reduce switching power
    if (q != next_q)
        q <= next_q;
end

endmodule