module TopModule (
    input  wire [31:0] in,  // 32-bit input vector
    output wire [31:0] out  // 32-bit output vector with bytes reversed
);

    reg [31:0] temp_out;

    always @(*) begin
        temp_out = 0;
        for (int i = 0; i < 4; i++) begin
            temp_out = temp_out | (in[(i*8)+:8] << ((3-i)*8));
        end
        out = temp_out;
    end

endmodule