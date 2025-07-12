module TopModule (
    input  [7:0] in,
    output reg   parity
);
    integer i;
    always @(*) begin
        parity = 0;
        for (i = 0; i < 8; i = i + 1)
            parity = parity ^ in[i];
    end
endmodule