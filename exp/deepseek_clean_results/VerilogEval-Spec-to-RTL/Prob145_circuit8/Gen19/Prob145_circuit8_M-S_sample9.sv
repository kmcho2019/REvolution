module TopModule (
    input clock,
    input a,
    output p,
    output reg q
);

// p is simply a AND clock
assign p = a & clock;

// q is p delayed by one clock cycle
always @(posedge clock) begin
    q <= p;
end

initial begin
    q = 1'b0;
end

endmodule