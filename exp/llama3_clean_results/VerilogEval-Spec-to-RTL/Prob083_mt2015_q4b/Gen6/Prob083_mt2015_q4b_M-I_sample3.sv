module TopModule(
    input x,
    input y,
    output reg z
);
    always @(*)
    begin
        // Logic implementation emphasizing conditions for z to be high
        z = (x & y) | (~x & ~y);
    end
endmodule