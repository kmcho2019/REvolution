module TopModule(
    input [99:0] in,
    output reg [99:0] out
);

always @(*) begin
    out = {<< {in}}; // Reversing the bits of in and assigning it to out
end

endmodule