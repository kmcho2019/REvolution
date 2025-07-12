// Module to calculate the even parity bit for an 8-bit input byte
module TopModule(
    input  [7:0] in,  // 8-bit input byte
    output parity    // 1-bit output for even parity
);

// Calculate the even parity bit by performing an XOR operation on all input bits
assign parity = ^in;  // Utilize Verilog's XOR reduction operator for efficiency

// Alternative implementation using a loop (not recommended due to potential performance overhead)
// reg [7:0] temp;
// integer i;
// always @(*) begin
//     temp = in;
//     parity = 1'b0;
//     for (i = 0; i < 8; i++) begin
//         parity = parity ^ temp[i];
//     end
// end

endmodule