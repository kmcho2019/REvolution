module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg p_next;

always @(posedge clock) begin
    if (~q) begin
        p <= a;  // p follows a only when q is 0
    end
    else begin
        p <= p;  // hold value when q is 1
    end
    
    // q becomes 1 only after p was 1 at a clock edge
    if (p && ~q) begin
        q <= 1;
    end
end

always @(negedge clock) begin
    if (a) begin
        q <= 0;  // asynchronous reset of q
    end
end

initial begin
    p = 0;
    q = 0;
end

endmodule