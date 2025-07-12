module TopModule (
    input clk,
    input a,
    output reg [2:0] q = 3'd4  // Initialize to 4 to match first output
);

always @(posedge clk) begin
    if (a) begin
        q <= q;  // hold value when a is high
    end else begin
        // increment with proper 3-bit wrap-around
        if (q == 3'd6)
            q <= 3'd0;
        else
            q <= q + 1'b1;
    end
end

endmodule