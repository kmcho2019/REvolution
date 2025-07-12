module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [7:0] odd
);

    reg [8:0] current_remainder;  // 9 bits for comparison (8+1)
    integer i;

    always @(*) begin
        current_remainder = 9'b0;
        result = 16'b0;

        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left and bring next dividend bit
            current_remainder = {current_remainder[7:0], A[i]};

            // Compare and subtract if possible
            if (current_remainder >= B) begin
                current_remainder = current_remainder - B;
                result[i] = 1'b1;
            end
            // else bit remains 0 (default)
        end

        odd = current_remainder[7:0];  // Final remainder (8 bits)
    end

endmodule