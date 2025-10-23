module TopModule (
    input clock,
    input a,
    output p,
    output reg q
);

assign p = clock & a;

always @(negedge clock) begin
    q <= p;
end

endmodule