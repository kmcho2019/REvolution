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

    reg [31:0] packed;

    always @(*) begin
        packed = 32'b0;
        // Pack inputs from MSB side towards LSB side
        // Start at bit 31, shift left and insert inputs sequentially
        packed = (a);
        packed = (packed << 5) | b;
        packed = (packed << 5) | c;
        packed = (packed << 5) | d;
        packed = (packed << 5) | e;
        packed = (packed << 5) | f;
        packed = (packed << 2) | 2'b11; // append two LSB bits '11'
    end

    assign w = packed[31:24];
    assign x = packed[23:16];
    assign y = packed[15:8];
    assign z = packed[7:0];

endmodule