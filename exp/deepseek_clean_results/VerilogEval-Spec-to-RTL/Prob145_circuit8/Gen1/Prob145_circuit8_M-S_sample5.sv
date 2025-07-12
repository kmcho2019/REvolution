module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(clock) begin
    if (clock) begin
        p <= a;
        q <= p;
    end
end

endmodule