module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    if (~q) begin
        p <= a;  // p follows a only when q is 0
    end
    
    if (p) begin
        q <= 1;  // q becomes 1 after p was 1
    end
end

always @(negedge clock) begin
    if (a) begin
        q <= 0;  // reset q when a is high during low clock
    end
end

initial begin
    p = 0;
    q = 0;
end

endmodule