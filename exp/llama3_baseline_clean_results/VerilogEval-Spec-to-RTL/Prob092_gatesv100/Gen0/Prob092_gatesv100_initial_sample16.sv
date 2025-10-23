module TopModule(
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

always @(*) begin
    // Initialize all output bits to 0
    out_both = 0;
    out_any = 0;
    out_different = 0;

    // Calculate out_both
    for (int i = 98; i >= 0; i--) begin
        out_both[i] = in[i] & in[i+1];
    end

    // Calculate out_any
    for (int i = 1; i <= 99; i++) begin
        out_any[i] = in[i] | in[i-1];
    end

    // Calculate out_different
    for (int i = 0; i < 100; i++) begin
        out_different[i] = ~(in[i] ^ (i == 99 ? in[0] : in[i+1]));
    end
end

endmodule