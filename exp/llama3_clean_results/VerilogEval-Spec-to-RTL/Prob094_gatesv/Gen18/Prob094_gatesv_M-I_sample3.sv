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
            // out_both: Simplify condition for the last bit
            assign out_both[i] = (i < 3) ? (in[i] & in[i+1]) : 1'b0;
            
            // out_any: Directly assign in[i] when i is 0 to reduce conditional checks
            assign out_any[i] = (i == 0) ? in[i] : (in[i] | in[i-1]);
            
            // out_different: Maintain the wrapping condition for the last bit
            assign out_different[i] = (i == 3) ? (in[i] ^ in[0]) : (in[i] ^ in[i+1]);
        end
    endgenerate
endmodule

// TopModule remains unchanged
module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);
    bitwise_operations_module operations_module(.in(in), .out_both(out_both), .out_any(out_any), .out_different(out_different));
endmodule