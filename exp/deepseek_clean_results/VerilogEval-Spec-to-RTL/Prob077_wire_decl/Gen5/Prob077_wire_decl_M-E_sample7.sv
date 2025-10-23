module TopModule (
    input a,
    input b,
    input c,
    input d,
    output reg out,
    output reg out_n
);

    always @* begin
        // First layer: AND operations
        reg and1 = a & b;
        reg and2 = c & d;
        
        // Second layer: OR operation and inversion
        out = and1 | and2;
        out_n = ~out;
    end

endmodule