module TopModule(
    input  [3:0] in,
    output reg [2:0] out_both,
    output reg [2:0] out_any,
    output reg [3:0] out_different
);

always @(*) begin
    // Calculate out_both: Each bit indicates if the corresponding input bit and its left neighbor are both '1'
    out_both[0] = in[0] & in[1];
    out_both[1] = in[1] & in[2];
    out_both[2] = in[2] & in[3];

    // Calculate out_any: Each bit indicates if the corresponding input bit or its right neighbor is '1'
    out_any[0] = in[1] | in[0];
    out_any[1] = in[2] | in[1];
    out_any[2] = in[3] | in[2];

    // Calculate out_different: Each bit indicates if the corresponding input bit is different from its left neighbor
    out_different[0] = in[0] ^ in[3]; // Wrap around for the most significant bit
    out_different[1] = in[1] ^ in[0];
    out_different[2] = in[2] ^ in[1];
    out_different[3] = in[3] ^ in[2];
end

endmodule