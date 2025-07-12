module TopModule (
    input [7:0] in,
    output [31:0] out
);
    // Sign extension using bitwise OR with mask
    wire [31:0] sign_mask = {32{in[7]}} & (32'hFFFFFF00);
    assign out = sign_mask | {24'b0, in};
endmodule