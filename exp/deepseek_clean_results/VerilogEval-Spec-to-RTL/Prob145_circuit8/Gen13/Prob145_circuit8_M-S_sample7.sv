module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock, negedge clock) begin
    // Reset q immediately if a is high
    if (a) begin
        q <= 0;
    end
    else if (clock) begin // rising edge
        if (~q) begin
            p <= a;  // p follows a only when q is 0
        end else begin
            p <= 0;  // p stays 0 when q is 1
        end
        
        // Set q if p was 1 in previous cycle
        q <= q | p;
    end
end

initial begin
    p = 1'bx;
    q = 1'bx;
end

endmodule