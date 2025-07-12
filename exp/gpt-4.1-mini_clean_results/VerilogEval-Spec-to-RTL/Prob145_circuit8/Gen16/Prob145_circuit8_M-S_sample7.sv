module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

initial begin
    p = 0;
    q = 0;
end

always @(posedge clock) begin
    p <= p | a; // Set p when a=1, hold otherwise
    q <= p;     // q follows previous p
end

endmodule