module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    p <= a; // p follows a when clock is high
end

always @(negedge clock) begin
    q <= a; // q updates to a when clock goes low
end

endmodule