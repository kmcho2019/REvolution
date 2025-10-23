// TopModule implements the logic described by the given Karnaugh map using a ROM-based approach.

module TopModule(
    input  [2:0] addr,  // Input signals a, b, c combined into a 3-bit address
    output reg out      // Output signal out
);

// Define the ROM contents based on the Karnaugh map.
// The order of the addresses is a'b'c', a'b c, a'bc, a'bc', ab'c', ab c, abc', abc.
reg [7:0] rom_data = 8'b01111111;

// Use the input address to select the output from the ROM.
always @(*) begin
    out = rom_data[addr];
end

endmodule