module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

initial begin
    p = 1'bx;
    q = 1'bx;
end

always @(posedge clock or negedge clock) begin
    if (clock) begin
        // posedge clock
        p <= a;
    end else begin
        // negedge clock
        q <= p;
    end
end

endmodule