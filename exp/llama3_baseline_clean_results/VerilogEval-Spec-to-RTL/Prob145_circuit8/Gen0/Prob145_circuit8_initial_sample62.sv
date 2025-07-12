module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    p <= a;
end

always @(negedge clock) begin
    if (a) begin
        q <= p;
    end else begin
        q <= 0;
    end
end

endmodule