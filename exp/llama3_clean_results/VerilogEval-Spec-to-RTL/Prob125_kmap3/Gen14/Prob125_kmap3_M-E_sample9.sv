module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Implementing the Karnaugh map using a lookup table (LUT)
// The LUT is programmed with the desired output for each input combination
// Here, we ignore 'd' as it's a don't-care, so we focus on 'a', 'b', and 'c'
// For simplicity and to match the don't-care condition, we assume 'd' does not affect the output directly

wire [1:0] ab; // Combine 'a' and 'b' for easier handling
wire [1:0] cd; // Combine 'c' and 'd' for easier handling, though 'd' is don't-care

assign ab = {a, b};
assign cd = {c, d};

// LUT implementation
always @(*) begin
    case ({ab, c}) // Using 'c' directly since 'd' is don't-care
        4'b0000: out = 1'b0; // a=0, b=0, c=0
        4'b0001: out = 1'b0; // a=0, b=0, c=1
        4'b0010: out = 1'b1; // a=0, b=1, c=0
        4'b0011: out = 1'b1; // a=0, b=1, c=1
        4'b1000: out = 1'b0; // a=1, b=0, c=0
        4'b1001: out = 1'b1; // a=1, b=0, c=1
        4'b1010: out = 1'b1; // a=1, b=1, c=0
        4'b1011: out = 1'b1; // a=1, b=1, c=1
        default: out = 1'b0; // Default case
    endcase
end

endmodule