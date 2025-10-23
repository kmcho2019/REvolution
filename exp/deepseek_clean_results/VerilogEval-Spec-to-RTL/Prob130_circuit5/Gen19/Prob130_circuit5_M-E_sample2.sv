module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

// Simplified invalid case detection (c >= 4)
wire invalid = c[2];

// Shared selection control
wire [1:0] sel = invalid ? 2'b00 : c[1:0];

// Bit-sliced output generation
genvar i;
generate
    for (i = 0; i < 4; i = i + 1) begin : bit_slice
        assign q[i] = 
            (sel == 2'b00) ? b[i] :
            (sel == 2'b01) ? e[i] :
            (sel == 2'b10) ? a[i] :
            (sel == 2'b11) ? d[i] :
            1'b1; // Default case (should never occur)
    end
endgenerate

endmodule