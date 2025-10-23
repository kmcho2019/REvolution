module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg a_prev;
reg p_prev;

always @(posedge clock) begin
    a_prev <= a;
    p_prev <= p;
    
    // Detect rising edge of 'a' during clock high
    if (~a_prev && a) begin
        p <= 1'b1;
    end else begin
        p <= 1'b0;
    end
end

always @(negedge clock) begin
    if (p_prev) begin
        q <= ~q;
    end
end

endmodule