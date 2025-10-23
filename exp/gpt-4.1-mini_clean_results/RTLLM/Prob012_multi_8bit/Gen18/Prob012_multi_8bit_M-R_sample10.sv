module multi_8bit (
    input  wire [7:0] A,
    input  wire [7:0] B,
    output reg  [15:0] product
);
    integer i;
    reg [15:0] acc;

    always @(*) begin
        acc = 16'b0;
        for (i = 0; i < 8; i = i + 1) begin
            if (B[i])
                acc = acc + (A << i);
        end
        product = acc;
    end

endmodule