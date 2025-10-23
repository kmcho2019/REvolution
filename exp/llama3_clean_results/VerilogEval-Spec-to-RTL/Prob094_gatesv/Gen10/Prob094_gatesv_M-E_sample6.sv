module TopModule(
    input  [3:0] in,
    output reg [3:0] out_both,
    output reg [3:0] out_any,
    output reg [3:0] out_different
);

    integer i;

    always @(*) begin
        for (i = 0; i < 4; i++) begin
            if (i == 3) begin
                out_both[i] = 1'b0;
                out_different[i] = in[i] ^ in[0];
            end else begin
                out_both[i] = in[i] & in[i+1];
                out_different[i] = in[i] ^ in[i+1];
            end

            if (i == 0) begin
                out_any[i] = in[i];
            end else begin
                out_any[i] = in[i] | in[i-1];
            end
        end
    end

endmodule