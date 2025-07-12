module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    reg [15:0] result;
    integer i;

    always @(*) begin
        result = 16'b0;
        for (i = 0; i < 8; i = i + 1) begin
            if (B[i]) begin
                result = result + (A << i);
            end
        end
    end

    assign product = result;

endmodule