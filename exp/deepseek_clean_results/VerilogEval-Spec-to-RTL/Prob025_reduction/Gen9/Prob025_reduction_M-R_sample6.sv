module TopModule (
    input [7:0] in,
    output reg parity
);
    always @(*) begin
        parity = ^in;  // Even parity calculation
    end
endmodule