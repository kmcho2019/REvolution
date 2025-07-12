module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    integer i;

    // Calculate out_both
    always @(*) begin
        out_both = 0;
        for (i = 0; i < 99; i++) begin
            out_both[i] = in[i] & in[i+1];
        end
    end

    // Calculate out_any
    always @(*) begin
        out_any = 0;
        for (i = 1; i < 100; i++) begin
            out_any[i] = in[i] | in[i-1];
        end
    end

    // Calculate out_different
    always @(*) begin
        for (i = 0; i < 100; i++) begin
            if (i == 0) begin
                out_different[i] = in[i] ^ in[99];
            end else begin
                out_different[i] = in[i] ^ in[i-1];
            end
        end
    end

endmodule