module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(*) begin
    if (clock) begin
        p = a;  // p follows a when clock is high
    end
    // else p retains its value (implicit in Verilog for sequential logic)
end

always @(negedge clock) begin
    q <= p;     // q captures p's value on negative clock edge
end

endmodule