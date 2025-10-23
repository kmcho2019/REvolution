module TopModule(
    input clk,
    input x,
    output z
);

reg q0, q1, q2;

always_ff @(posedge clk) begin
    q0 <= x ^ q0;
    q1 <= x & ~q1;
    q2 <= x | ~q2;
end

assign z = ~( (x ^ q0) | (x & ~q1) | (x | ~q2) );

endmodule