module TopModule (
    input [7:0] in,
    output reg parity
);
    always @(*) begin
        parity = ^in;  // Same XOR reduction but using procedural assignment
    end
endmodule