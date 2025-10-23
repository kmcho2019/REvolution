module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output reg [7:0] s,
    output overflow
);
    reg [8:0] sum_ext;

    always @* begin
        sum_ext = {1'b0, a} + {1'b0, b};
        s = sum_ext[7:0];
    end

    // Overflow: XOR of carry into MSB and carry out of MSB
    // carry into MSB is sum_ext[7], carry out MSB is sum_ext[8]
    assign overflow = sum_ext[7] ^ sum_ext[8];
endmodule