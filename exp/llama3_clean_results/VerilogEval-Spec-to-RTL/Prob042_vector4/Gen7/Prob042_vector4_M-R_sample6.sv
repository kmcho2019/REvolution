module TopModule(
    input  [7:0] in,
    output [31:0] out
);
    reg [31:0] out_reg;

    always @(*) begin
        reg [23:0] sign_extension;
        // Replicate the sign bit 24 times
        for (int i = 0; i < 24; i++) begin
            sign_extension[i] = in[7];
        end
        // Concatenate the sign extension with the original input
        out_reg = {sign_extension, in};
    end

    assign out = out_reg;
endmodule