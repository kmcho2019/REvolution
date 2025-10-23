module TopModule (
    input  [7:0] in,
    output [31:0] out
);
    wire [31:0] sign_mask = {32{in[7]}} & (32'hFFFFFF00);
    wire [31:0] zero_ext  = {24'b0, in};
    assign out = sign_mask | zero_ext;
endmodule