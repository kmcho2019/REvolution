module TopModule (
    input clk,
    input a,
    output reg [2:0] q = 3'd4  // initialize to 4
);

always @(posedge clk) begin
    if (a) begin
        q <= q;  // hold value when a is high
    end else begin
        q <= (q == 3'd6) ? 3'd0 : q + 3'd1;  // increment and wrap around
    end
end

endmodule