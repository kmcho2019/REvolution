// Parameterizable module for bitwise operations
module bitwise_operations_module(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);
    genvar i;
    generate
        for (i = 0; i < 4; i++) begin
            // Simplify expressions if possible and directly handle edge cases
            assign out_both[i] = (i < 3)? in[i] & in[i+1] : 1'b0;
            assign out_any[i]  = (i > 0)? in[i] | in[i-1] : in[i];
            // Use a direct approach for the wrap-around case in out_different
            assign out_different[i] = (i == 3)? in[i] ^ in[0] : in[i] ^ in[i+1];
        end
    endgenerate
endmodule

// TopModule instantiating the parameterizable module
module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);
    bitwise_operations_module operations_module(.in(in),.out_both(out_both),.out_any(out_any),.out_different(out_different));
endmodule