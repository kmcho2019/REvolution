module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product
);

    integer i;
    reg [15:0] temp;

    always @(A or B) begin
        temp = 0;
        for (i = 0; i < 8; i++) begin
            if (B[i]) begin
                temp = temp + (A << i);
            end
        end
        product = temp;
    end

endmodule