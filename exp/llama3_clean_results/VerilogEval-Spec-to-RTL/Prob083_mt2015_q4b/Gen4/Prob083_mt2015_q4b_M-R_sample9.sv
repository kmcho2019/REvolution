module TopModule(
    input x,
    input y,
    output reg z
);
    always @(*)
    begin
        // Using the most efficient logic implementation within an always block
        z = ~(x ^ y);
    end
endmodule