module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

reg a_d; // delayed version of 'a' to detect edges

always @(posedge clk) begin
    a_d <= a;
    if (a && !a_d) begin
        // a just went high: set q to 4
        q <= 3'd4;
    end else if (a) begin
        // a is still high, hold q (stay at 4)
        q <= q;
    end else begin
        // a is low: increment q modulo 8
        q <= q + 3'd1;
    end
end

endmodule