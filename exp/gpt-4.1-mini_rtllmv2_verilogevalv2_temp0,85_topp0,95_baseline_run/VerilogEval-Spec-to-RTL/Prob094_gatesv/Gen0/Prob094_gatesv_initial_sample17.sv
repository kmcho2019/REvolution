module TopModule (
    input  [3:0] in,
    output reg [3:0] out_both,
    output reg [3:0] out_any,
    output reg [3:0] out_different
);

    always @(*) begin
        // out_both: check if both current bit and left neighbor (higher index) are 1
        // For bits 0 to 2, left neighbor is in[i+1]
        out_both[0] = in[0] & in[1];
        out_both[1] = in[1] & in[2];
        out_both[2] = in[2] & in[3];
        out_both[3] = 1'b0; // no left neighbor for in[3]
        
        // out_any: check if current bit or right neighbor (lower index) is 1
        // For bits 1 to 3, right neighbor is in[i-1]
        out_any[0] = 1'b0; // no right neighbor for in[0]
        out_any[1] = in[1] | in[0];
        out_any[2] = in[2] | in[1];
        out_any[3] = in[3] | in[2];
        
        // out_different: check if current bit differs from left neighbor (wrapping around)
        // left neighbor of in[3] is in[0]
        out_different[0] = in[0] ^ in[1];
        out_different[1] = in[1] ^ in[2];
        out_different[2] = in[2] ^ in[3];
        out_different[3] = in[3] ^ in[0];
    end

endmodule