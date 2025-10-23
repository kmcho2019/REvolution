module TopModule(
    input [254:0] in,
    output [7:0] out
);

    // Count the number of '1's in each byte
    wire [7:0] byte_counts [31:0];
    genvar i;
    generate
        for (i = 0; i < 32; i++) begin
            always @(in) begin
                byte_counts[i] = {8{1'b0}};
                for (int j = 0; j < 8; j++) begin
                    byte_counts[i] += in[i*8 + j];
                end
            end
        end
    endgenerate

    // Add up the byte counts and the leftover bit
    always @(byte_counts, in) begin
        out = {8{1'b0}};
        for (int i = 0; i < 32; i++) begin
            out += byte_counts[i];
        end
        out += in[254];
    end

endmodule