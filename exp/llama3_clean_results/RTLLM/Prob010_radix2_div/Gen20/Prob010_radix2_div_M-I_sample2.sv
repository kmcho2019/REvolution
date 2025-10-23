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

// Registers
reg [7:0] remainder;
reg [7:8] quotient;
reg [7:0] neg_divisor;
reg [2:0] cnt;
reg start_div;

// Wires
wire [7:0] abs_dividend;
wire [7:0] abs_divisor;

// Assign absolute values
assign abs_dividend = (sign && dividend[7]) ? (~dividend + 1) : dividend;
assign abs_divisor = (sign && divisor[7]) ? (~divisor + 1) : divisor;

always @(posedge clk) begin
    if (rst) begin
        res_valid <= 0;
        remainder <= 0;
        quotient <= 0;
        neg_divisor <= 0;
        cnt <= 0;
        start_div <= 0;
    end else if (opn_valid && !res_valid) begin
        // Initialize division process
        if (abs_divisor == 0) begin
            // Handle division by zero error
            result <= {8'hFF, 8'hFF}; // Return max value for remainder and quotient
            res_valid <= 1;
            start_div <= 0;
        end else begin
            remainder <= {1'b0, abs_dividend}; // Sign extend dividend
            neg_divisor <= (sign && divisor[7]) ? abs_divisor : ~abs_divisor + 1;
            quotient <= 0;
            cnt <= 1;
            start_div <= 1;
        end
    end else if (start_div) begin
        if (cnt < 8) begin
            // Perform division
            if (remainder >= neg_divisor) begin
                remainder <= remainder - neg_divisor;
                quotient <= quotient + (1 << (8 - cnt));
            end else begin
                remainder <= remainder << 1;
            end
            cnt <= cnt + 1;
        end else begin
            // Finalize division result
            res_valid <= 1;
            result <= {remainder[7:0], quotient[7:0]};
            start_div <= 0;
        end
    end else if (res_valid && !opn_valid) begin
        // Reset division result
        res_valid <= 0;
    end
end

endmodule