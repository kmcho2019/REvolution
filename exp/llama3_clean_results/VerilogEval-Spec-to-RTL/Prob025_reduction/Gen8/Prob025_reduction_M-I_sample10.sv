// Module to calculate the even parity bit for an 8-bit input byte
module TopModule(
    input  wire [7:0] in,  // 8-bit input byte
    output reg parity    // 1-bit output for even parity
);

// Calculate the even parity bit by performing an XOR operation on all input bits
always @(*) begin
    parity = ^in;  // Utilize Verilog's XOR reduction operator for efficiency
end

endmodule