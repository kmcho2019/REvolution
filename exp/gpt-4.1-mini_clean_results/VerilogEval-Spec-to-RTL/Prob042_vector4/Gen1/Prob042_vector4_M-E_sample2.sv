module TopModule (
    input  [7:0] in,
    output [31:0] out
);
    wire [31:0] extended_zero = {24'b0, in};
    wire [31:0] sign_mask = {24{1'b1}} << 8; // mask to cover upper 24 bits

    assign out = in[7] ? (extended_zero | sign_mask) : extended_zero;
endmodule