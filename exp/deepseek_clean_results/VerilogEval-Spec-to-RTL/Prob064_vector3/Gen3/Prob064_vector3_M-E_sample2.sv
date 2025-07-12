module TopModule (
    input [4:0] a,
    input [4:0] b,
    input [4:0] c,
    input [4:0] d,
    input [4:0] e,
    input [4:0] f,
    output [7:0] w,
    output [7:0] x,
    output [7:0] y,
    output [7:0] z
);

    // Build the 32-bit output in stages
    reg [31:0] temp;

    always @(*) begin
        // Start with the two LSB '1' bits
        temp = 32'b00000000000000000000000000000011;
        
        // Shift and concatenate inputs in reverse order (f to a)
        temp = (temp << 5) | f;
        temp = (temp << 5) | e;
        temp = (temp << 5) | d;
        temp = (temp << 5) | c;
        temp = (temp << 5) | b;
        temp = (temp << 5) | a;
    end

    // Extract outputs using bit masking
    assign w = (temp >> 24) & 8'hFF;
    assign x = (temp >> 16) & 8'hFF;
    assign y = (temp >> 8)  & 8'hFF;
    assign z = temp         & 8'hFF;

endmodule