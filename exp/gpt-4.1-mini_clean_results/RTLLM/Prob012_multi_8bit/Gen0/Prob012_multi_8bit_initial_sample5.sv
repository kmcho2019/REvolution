module multi_8bit (
    input  [7:0] A,
    input  [7:0] B,
    output [15:0] product
);
    integer i;
    reg [15:0] result;
    reg [15:0] shifted_A;

    always @(*) begin
        result = 16'b0;
        shifted_A = {8'b0, A}; // Extend A to 16 bits for addition
        for (i = 0; i < 8; i = i + 1) begin
            if (B[i])
                result = result + shifted_A;
            shifted_A = shifted_A << 1;
        end
    end

    assign product = result;

endmodule