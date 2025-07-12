module TopModule (
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);
    genvar i;
    
    // out_both: bit i = in[i] & in[i+1] if i<3 else 0
    generate
        for (i = 0; i < 4; i = i + 1) begin : gen_out_both
            if (i < 3)
                assign out_both[i] = in[i] & in[i+1];
            else
                assign out_both[i] = 1'b0;
        end
    endgenerate
    
    // out_any: bit i = in[i] | in[i-1] if i>0 else 0
    generate
        for (i = 0; i < 4; i = i + 1) begin : gen_out_any
            if (i > 0)
                assign out_any[i] = in[i] | in[i-1];
            else
                assign out_any[i] = 1'b0;
        end
    endgenerate
    
    // out_different: bit i = in[i] ^ in[(i+1) mod 4] (wrap-around)
    generate
        for (i = 0; i < 4; i = i + 1) begin : gen_out_different
            localparam int left_neighbor = (i + 1) % 4;
            assign out_different[i] = in[i] ^ in[left_neighbor];
        end
    endgenerate
endmodule