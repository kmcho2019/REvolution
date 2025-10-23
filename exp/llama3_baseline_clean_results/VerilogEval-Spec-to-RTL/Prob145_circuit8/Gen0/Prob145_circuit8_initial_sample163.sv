module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(negedge clock) begin
    p <= 0;
    q <= 0;
end

always @(posedge clock) begin
    if(a) begin
        p <= 1;
        q <= p;
    end else begin
        p <= 0;
        q <= q;
    end
end

endmodule