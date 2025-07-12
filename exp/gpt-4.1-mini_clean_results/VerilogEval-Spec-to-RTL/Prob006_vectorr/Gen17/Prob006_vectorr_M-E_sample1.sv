module TopModule (
    input  wire [7:0] in,
    output reg  [7:0] out
);
    integer i;
    always @(*) begin
        out = 0;
        // Shift in bits from MSB to LSB of 'in' into 'out' from LSB to MSB
        for (i = 0; i < 8; i = i + 1) begin
            out = (out << 1) | in[i];
        end
    end
endmodule