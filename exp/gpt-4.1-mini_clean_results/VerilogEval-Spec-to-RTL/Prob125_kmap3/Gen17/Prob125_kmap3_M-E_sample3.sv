module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // don't care input
    output reg out
);

always @(*) begin
    // Inputs combined to 3-bit vector: {a,b,c}
    // Map these to output based on Karnaugh map and ignoring d input (don't care)
    case ({a,b,c})
        3'b000: out = 0; // ab=00, c=0; cd=00 => d (don't care), choose 0
        3'b001: out = 1; // ab=00, c=1; cd=00 => 1
        3'b010: out = 1; // ab=01, c=0; cd=00 => d, choose 1
        3'b011: out = 0; // ab=01, c=1; cd=00 => 0
        3'b100: out = 1; // ab=10, c=0; cd=00 => 1
        3'b101: out = 1; // ab=10, c=1; cd=00 => 1
        3'b110: out = 1; // ab=11, c=0; cd=00 => 1
        3'b111: out = 1; // ab=11, c=1; cd=00 => 1
        default: out = 0;
    endcase
end

endmodule