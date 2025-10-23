module float_multi(
    input clk, rst,
    input [31:0] a, b,
    output reg [31:0] z
);

    reg [8:0] exponent_a, exponent_b, result_exponent;
    reg [23:0] mantissa_a, mantissa_b, result_mantissa;
    reg sign_a, sign_b, result_sign;
    wire [47:0] product;
    reg [23:0] temp_mantissa;

    // Extract exponent, mantissa, and sign from inputs
    assign exponent_a = a[30:23];
    assign exponent_b = b[30:23];
    assign mantissa_a = {1'b1, a[22:0]}; // implicit leading 1
    assign mantissa_b = {1'b1, b[22:0]}; // implicit leading 1
    assign sign_a = a[31];
    assign sign_b = b[31];

    // Calculate result exponent and mantissa
    assign product = mantissa_a * mantissa_b;
    assign result_exponent = exponent_a + exponent_b - 9'd127;
    assign result_sign = sign_a ^ sign_b;

    // Normalize result mantissa
    assign temp_mantissa = (product[47:24] == 0) ? product[23:0] : product[46:23] + (product[22] || product[21:0] != 0);
    assign result_mantissa = temp_mantissa;

    // Generate final output
    always @(posedge clk) begin
        if (rst) begin
            z <= 0;
        end else begin
            if ((exponent_a == 9'd255) || (exponent_b == 9'd255)) begin
                // NaN
                z <= {1'b1, 8'd255, 23'd0};
            end else if (((exponent_a == 9'd255) && (mantissa_a[23:0] == 0)) || ((exponent_b == 9'd255) && (mantissa_b[23:0] == 0))) begin
                // Infinity
                z <= {result_sign, 8'd255, 23'd0};
            end else if (result_exponent > 9'd254) begin
                // Overflow
                z <= {result_sign, 8'd255, 23'd0};
            end else if (result_exponent < 1) begin
                // Underflow
                z <= {result_sign, 8'd0, 23'd0};
            end else begin
                z <= {result_sign, result_exponent, result_mantissa[23:0]};
            end
        end
    end

endmodule