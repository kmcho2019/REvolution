module multi_8bit (
    input  [7:0] A,
    input  [7:0] B,
    output [15:0] product
);

    integer i;
    reg [15:0] temp_product;
    reg [15:0] shifted_A;

    always @* begin
        temp_product = 16'd0;
        shifted_A = {8'd0, A}; // extend A to 16 bits
        for (i = 0; i < 8; i = i + 1) begin
            if (B[i])
                temp_product = temp_product + (shifted_A << i);
        end
    end

    assign product = temp_product;

endmodule