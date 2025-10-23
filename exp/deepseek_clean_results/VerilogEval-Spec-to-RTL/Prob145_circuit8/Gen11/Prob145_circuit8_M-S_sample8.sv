module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    if (~q) begin
        p <= a;  // p follows a only when q is 0
    end else begin
        p <= 0;  // p stays 0 when q is 1
    end
    
    q <= (p & ~q) | (q & ~(a & ~clock));  // Set q if p was 1, reset if a during low clock
end

initial begin
    p = 0;
    q = 0;
end

endmodule