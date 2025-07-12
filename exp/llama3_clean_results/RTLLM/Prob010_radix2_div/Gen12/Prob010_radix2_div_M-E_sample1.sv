module radix2_div(
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output reg res_valid,
    output reg [15:0] result
);

// Define the LUT size
parameter LUT_SIZE = 256;

// Declare the LUT
reg [7:0] lut[LUT_SIZE-1:0];

// Initialize the LUT
integer i;
always @(posedge clk or posedge rst) begin
    if (rst) begin
        for (i = 0; i < LUT_SIZE; i++) begin
            lut[i] <= i - divisor;
        end
    end
end

// Declare internal signals
reg [7:0] quotient;
reg [7:0] remainder;
reg [7:0] dividend_aligned;
reg [3:0] lut_index;

// Perform division
always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        result <= 0;
    end else if (opn_valid && !res_valid) begin
        if (divisor == 0) begin
            // Handle division by zero
            res_valid <= 1;
            result <= {8'd0, 8'd0};  // undefined result
        end else if (sign) begin
            // Signed division
            dividend_aligned <= (dividend[7] ? (~dividend + 8'd1) : dividend);
        end else begin
            // Unsigned division
            dividend_aligned <= dividend;
        end
        lut_index <= dividend_aligned[7:4];
        res_valid <= 0;
    end else if (!res_valid) begin
        // Retrieve pre-computed result from LUT
        remainder <= lut[lut_index];
        quotient <= dividend_aligned[3:0];
        if (remainder < 0) begin
            // Borrow
            quotient <= quotient - 1;
            remainder <= remainder + divisor;
        end
        result <= {remainder, quotient};
        res_valid <= 1;
    end
end

endmodule