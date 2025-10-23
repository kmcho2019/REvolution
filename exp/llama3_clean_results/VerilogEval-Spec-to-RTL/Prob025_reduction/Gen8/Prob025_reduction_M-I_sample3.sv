// Module to calculate the even parity bit for an 8-bit input byte
module TopModule(
    input  wire [7:0] in,  // 8-bit input byte, explicitly declaring as wire
    output reg parity    // 1-bit output for even parity, explicitly declaring as reg
);

// Calculate the even parity bit by performing an XOR operation on all input bits
always @(*) begin
    // Utilize Verilog's XOR reduction operator for efficiency
    parity = ^in;
end

endmodule