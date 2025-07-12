// TopModule to calculate the even parity bit of an 8-bit byte
module TopModule(
    input  [7:0] in,  // 8-bit input byte
    output reg parity  // 1-bit parity output
);

// Calculate the parity bit by XORing all input bits
always @(*) begin
    // The ^ operator performs XOR on all bits of the vector
    parity = ^in;  
end

endmodule