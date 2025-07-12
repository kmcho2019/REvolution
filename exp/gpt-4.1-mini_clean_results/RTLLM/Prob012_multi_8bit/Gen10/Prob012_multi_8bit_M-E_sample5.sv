module multi_8bit (
    input  wire [7:0] A,
    input  wire [7:0] B,
    output reg  [15:0] product
);

    integer i;
    reg [15:0] accum;
    reg [15:0] shifted_A;

    always @(*) begin
        accum = 16'b0;
        shifted_A = {8'b0, A}; // Extend A to 16 bits for shifting
        for (i = 0; i < 8; i = i + 1) begin
            if (B[i]) begin
                accum = accum + shifted_A;
            end
            shifted_A = shifted_A << 1;
        end
        product = accum;
    end

endmodule