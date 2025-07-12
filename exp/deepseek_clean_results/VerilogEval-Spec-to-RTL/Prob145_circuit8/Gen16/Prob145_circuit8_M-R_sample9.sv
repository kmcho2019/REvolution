module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg prev_p;

always @(posedge clock) begin
    if (q) begin
        p <= 0;
        // q remains 1 unless we saw 'a' high during low phase
        if (a) q <= 0;
    end else begin
        p <= a;
    end
    
    prev_p <= p;
    if (prev_p) q <= 1;
end

initial begin
    p = 0;
    q = 0;
    prev_p = 0;
end

endmodule