module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

wire q_reset = ~clock & a;  // asynchronous reset condition

always @(posedge clock or posedge q_reset) begin
    if (q_reset) begin
        q <= 0;  // asynchronous reset
    end else begin
        if (~q) begin
            p <= a;  // p follows a only when q is 0
        end
        
        // q gets set in the cycle after p was 1
        if (p) begin
            q <= 1;
        end
    end
end

initial begin
    p = 0;
    q = 0;
end

endmodule