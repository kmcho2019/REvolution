module TopModule (
    input  [4:0] a,
    input  [4:0] b,
    input  [4:0] c,
    input  [4:0] d,
    input  [4:0] e,
    input  [4:0] f,
    output [7:0] w,
    output [7:0] x,
    output [7:0] y,
    output [7:0] z
);

    reg [31:0] combined;

    always @(*) begin
        // Concatenate all inputs to form 30 bits
        // Then shift left by 2 bits to make room for appended bits
        combined = ({a, b, c, d, e, f} << 2) | 2'b11;
    end

    // Assign output slices from combined vector
    assign w = combined[31:24];
    assign x = combined[23:16];
    assign y = combined[15:8];
    assign z = combined[7:0];

endmodule