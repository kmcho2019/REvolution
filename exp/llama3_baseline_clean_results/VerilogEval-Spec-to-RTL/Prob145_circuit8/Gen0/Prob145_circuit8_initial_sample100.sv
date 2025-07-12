module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    if(a) begin
        q <= 1'b1; // Set q high if a is high during the positive edge of clock
    end
end

always @(*) begin
    p = clock & a; // p is high if both clock and a are high
end

endmodule