module div_16bit(
    input  wire [15:0] A,
    input  wire [7:0]  B,
    output reg  [15:0] result,
    output reg  [15:0] odd
);

    integer i;
    reg [7:0] remainder;     // remainder register (8 bits)
    reg [15:0] quotient;

    always @(*) begin
        remainder = 0;
        quotient = 0;

        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1 and bring in next dividend bit from A[i]
            remainder = {remainder[6:0], A[i]};
            if (remainder >= B) begin
                remainder = remainder - B;
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end

        result = quotient;
        // Place 8-bit remainder in lower bits of odd; upper bits zeroed
        odd = {8'd0, remainder};
    end

endmodule