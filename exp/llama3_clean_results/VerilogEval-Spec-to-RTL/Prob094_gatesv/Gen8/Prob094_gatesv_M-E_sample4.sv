module TopModule(
    input  [3:0] in,
    output reg [3:0] out_both,
    output reg [3:0] out_any,
    output reg [3:0] out_different
);

    integer i;

    always @(*) begin
        // Initialize output vectors
        out_both = 4'b0000;
        out_any = 4'b0000;
        out_different = 4'b0000;

        // Calculate out_both
        for (i = 0; i < 3; i++) begin
            out_both[i] = in[i] & in[i+1];
        end

        // Calculate out_any
        out_any[0] = in[0];
        for (i = 1; i < 4; i++) begin
            out_any[i] = in[i] | in[i-1];
        end

        // Calculate out_different
        out_different[3] = in[3] ^ in[0];
        for (i = 0; i < 3; i++) begin
            out_different[i] = in[i] ^ in[i+1];
        end
    end

endmodule