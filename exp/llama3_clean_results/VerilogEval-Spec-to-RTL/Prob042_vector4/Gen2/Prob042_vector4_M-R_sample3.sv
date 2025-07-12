module TopModule(
    input  [7:0] in,
    output [31:0] out
);

reg [23:0] sign_bit_replication;

always @(*) begin
    sign_bit_replication = {24{in[7]}};
    out = {sign_bit_replication, in};
end

endmodule