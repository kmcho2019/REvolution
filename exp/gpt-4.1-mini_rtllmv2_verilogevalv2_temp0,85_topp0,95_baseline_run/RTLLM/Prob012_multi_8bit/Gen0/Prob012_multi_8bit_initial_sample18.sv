module multi_8bit (
    input  [7:0] A,
    input  [7:0] B,
    output [15:0] product
);
    integer i;
    reg [15:0] temp_product;
    reg [15:0] shifted_A;

    always @(*) begin
        temp_product = 16'b0;
        shifted_A = {8'b0, A}; // zero-extend A to 16 bits

        for (i = 0; i < 8; i = i + 1) begin
            if (B[i]) begin
                temp_product = temp_product + (shifted_A << i);
            end
        end
    end

    assign product = temp_product;

endmodule