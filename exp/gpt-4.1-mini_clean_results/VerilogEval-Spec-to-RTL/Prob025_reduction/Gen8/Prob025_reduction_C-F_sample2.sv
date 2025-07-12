module TopModule (
    input  [7:0] in,
    output reg   parity
);
    always @(*) begin
        parity = ^in;  // Use reduction XOR operator inside always block for clarity and optimal synthesis
    end
endmodule