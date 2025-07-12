module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [7:0] odd
);

    reg [8:0] rem;  // 9-bit remainder (8+1 for comparison)
    integer i;

    always @(*) begin
        rem = 9'b0;
        for (i = 15; i >= 0; i = i - 1) begin
            rem = {rem[7:0], A[i]};  // Shift left and append next bit
            result[i] = (rem >= B);
            rem = result[i] ? (rem - B) : rem;
        end
        odd = rem[7:0];
    end

endmodule