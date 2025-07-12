module multi_8bit (
    input  [7:0] A,
    input  [7:0] B,
    output reg [15:0] product
);
    integer i;
    reg [15:0] shifted_A;

    always @(*) begin
        product = 16'd0;
        shifted_A = {8'd0, A};  // Extend A to 16 bits, zero-extend upper bits
        for (i = 0; i < 8; i = i + 1) begin
            if (B[i])
                product = product + shifted_A;
            shifted_A = shifted_A << 1;
        end
    end

endmodule