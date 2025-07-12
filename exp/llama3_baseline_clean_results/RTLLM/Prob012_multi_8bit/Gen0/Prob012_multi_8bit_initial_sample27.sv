module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    assign product = (A == 0 || B == 0) ? 16'd0 : 
                    (A == 1) ? {8'd0, B} : 
                    (B == 1) ? {8'd0, A} : 
                    A * B;

// However, since the above code does not follow the shift and add method, 
// let's implement the multiplier using the shift-and-add method.

module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product
);

    always @(*) begin
        product = 16'd0;
        for (int i = 0; i < 8; i++) begin
            if (B[i]) begin
                product = product + (A << i);
            end
        end
    end

endmodule

// Alternatively, a more correct implementation without using a for loop and 
// in a more synthesizable way could be:
module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product
);

    always @(*) begin
        product = 16'd0;
        product = (B[0] ? A : 16'd0) +
                  (B[1] ? (A << 1) : 16'd0) +
                  (B[2] ? (A << 2) : 16'd0) +
                  (B[3] ? (A << 3) : 16'd0) +
                  (B[4] ? (A << 4) : 16'd0) +
                  (B[5] ? (A << 5) : 16'd0) +
                  (B[6] ? (A << 6) : 16'd0) +
                  (B[7] ? (A << 7) : 16'd0);
    end

endmodule