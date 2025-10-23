module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    p <= a;
    if (a) begin
        q <= 1;
    end else if (!p) begin
        q <= 0;
    end
end

endmodule