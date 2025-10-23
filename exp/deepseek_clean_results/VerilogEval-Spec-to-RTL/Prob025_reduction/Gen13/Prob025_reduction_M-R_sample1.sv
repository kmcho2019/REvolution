module TopModule (
    input [7:0] in,
    output reg parity
);
    integer i;
    always @(*) begin
        parity = 1'b0;  // Initialize for even parity
        for (i = 0; i < 8; i = i + 1) begin
            parity = parity ^ in[i];
        end
    end
endmodule