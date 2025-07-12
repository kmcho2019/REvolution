module TopModule (
    input  [7:0] in,
    output [31:0] out
);
    // Bitwise conditional sign extension
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : sign_extend
            if (i < 8) begin
                assign out[i] = in[i];  // Direct copy for lower 8 bits
            end else begin
                assign out[i] = in[7];  // Sign bit replication for upper 24 bits
            end
        end
    endgenerate
endmodule