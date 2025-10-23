module right_shifter (
    input wire clk,
    input wire d,
    output reg [7:0] q
);

initial q = 8'b0;

always @(posedge clk) begin
    // Shift q right by 1 bit
    reg [7:0] shifted;
    shifted = q >> 1;

    // Clear MSB of shifted and insert new d bit
    // mask out bit 7 and OR with (d << 7)
    q <= (shifted & 8'h7F) | (d << 7);
end

endmodule