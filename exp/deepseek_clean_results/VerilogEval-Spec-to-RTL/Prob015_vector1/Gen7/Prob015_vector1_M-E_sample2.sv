module TopModule (
    input  [15:0] in,
    output reg [7:0] out_hi,
    output reg [7:0] out_lo
);

    // Struct-like organization using concatenation
    wire [15:0] word = in;
    wire [7:0] upper_byte, lower_byte;

    // Procedural assignment approach
    always @(*) begin
        {upper_byte, lower_byte} = word;  // Struct-like unpacking
        out_hi = upper_byte;
        out_lo = lower_byte;
    end

endmodule