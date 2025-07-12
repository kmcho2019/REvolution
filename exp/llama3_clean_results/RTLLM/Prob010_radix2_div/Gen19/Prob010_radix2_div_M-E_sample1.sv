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

// Normalization stage
reg [7:0] normalized_divisor;
reg [7:0] normalized_dividend;
reg [7:0] shift_amount;

always @(posedge clk) begin
    if (rst) begin
        normalized_divisor <= 0;
        normalized_dividend <= 0;
        shift_amount <= 0;
    end else begin
        if (opn_valid &&!res_valid) begin
            // Normalize the divisor
            if (divisor[7] == 1'b0) begin
                normalized_divisor <= divisor;
                shift_amount <= 0;
            end else begin
                normalized_divisor <= divisor >> 1;
                shift_amount <= 1;
            end
            normalized_dividend <= dividend;
        end
    end
end

// Multiplexing stage
reg [7:0] selected_divisor;
reg [7:0] selected_dividend;

always @(posedge clk) begin
    if (rst) begin
        selected_divisor <= 0;
        selected_dividend <= 0;
    end else begin
        if (opn_valid &&!res_valid) begin
            // Select the divisor or its complement
            if (sign) begin
                if (dividend[7] == 1'b0 && divisor[7] == 1'b0) begin
                    selected_divisor <= normalized_divisor;
                    selected_dividend <= normalized_dividend;
                end else if (dividend[7] == 1'b1 && divisor[7] == 1'b0) begin
                    selected_divisor <= normalized_divisor;
                    selected_dividend <= ~normalized_dividend + 1;
                end else if (dividend[7] == 1'b0 && divisor[7] == 1'b1) begin
                    selected_divisor <= ~normalized_divisor + 1;
                    selected_dividend <= normalized_dividend;
                end else begin
                    selected_divisor <= ~normalized_divisor + 1;
                    selected_dividend <= ~normalized_dividend + 1;
                end
            end else begin
                selected_divisor <= normalized_divisor;
                selected_dividend <= normalized_dividend;
            end
        end
    end
end

// Radix-2 division stage
reg [15:0] quotient;
reg [7:0] remainder;

always @(posedge clk) begin
    if (rst) begin
        quotient <= 0;
        remainder <= 0;
    end else begin
        if (opn_valid &&!res_valid) begin
            // Perform radix-2 division
            for (int i = 7; i >= 0; i--) begin
                if (remainder >= selected_divisor) begin
                    remainder <= remainder - selected_divisor;
                    quotient[7 - i] <= 1'b1;
                end else begin
                    quotient[7 - i] <= 1'b0;
                end
                remainder <= {remainder[6:0], selected_dividend[7]};
            end
        end
    end
end

// Result formatting stage
always @(posedge clk) begin
    if (rst) begin
        res_valid <= 0;
        result <= 0;
    end else begin
        if (opn_valid &&!res_valid) begin
            // Format the result
            if (sign) begin
                if (dividend[7] == 1'b0 && divisor[7] == 1'b0) begin
                    result <= {remainder, quotient};
                end else if (dividend[7] == 1'b1 && divisor[7] == 1'b0) begin
                    result <= {~remainder + 1, ~quotient + 1};
                end else if (dividend[7] == 1'b0 && divisor[7] == 1'b1) begin
                    result <= {remainder, ~quotient + 1};
                end else begin
                    result <= {~remainder + 1, quotient};
                end
            end else begin
                result <= {remainder, quotient};
            end
            res_valid <= 1;
        end else if (res_valid) begin
            res_valid <= 0;
        end
    end
end

endmodule