module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // out_both
    always @(*) begin
        for (int i = 0; i < 3; i++) begin
            out_both[i] = in[i] & in[i+1];
        end
        out_both[3] = 1'b0; // Directly assign 0 for the most significant bit
    end

    // out_any
    always @(*) begin
        out_any[0] = in[0]; // Handle the least significant bit directly
        for (int i = 1; i < 4; i++) begin
            out_any[i] = in[i] | in[i-1];
        end
    end

    // out_different
    always @(*) begin
        for (int i = 0; i < 4; i++) begin
            if (i == 3) begin
                out_different[i] = in[i] ^ in[0];
            end else begin
                out_different[i] = in[i] ^ in[i+1];
            end
        end
    end

endmodule