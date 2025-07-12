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

// Registered inputs
reg [7:0] dividend_reg;
reg [7:0] divisor_reg;

// Division variables
reg [8:0] remainder;
reg [7:0] quotient;
reg [3:0] cnt; // Counter
reg start_div; // Flag to start division

// Initialize variables
always @(posedge clk or posedge rst) begin
    if (rst) begin
        dividend_reg <= 8'd0;
        divisor_reg <= 8'd0;
        remainder <= 9'd0;
        quotient <= 8'd0;
        cnt <= 4'd0;
        start_div <= 1'b0;
        res_valid <= 1'b0;
    end else begin
        if (opn_valid) begin
            // Save inputs
            dividend_reg <= (sign && dividend[7]) ? ~dividend + 1 : dividend;
            divisor_reg <= (sign && divisor[7]) ? ~divisor + 1 : divisor;
            start_div <= 1'b1;
        end

        if (start_div) begin
            // Start division
            if (cnt == 4'd0) begin
                remainder <= {1'b0, dividend_reg};
                quotient <= 8'd0;
                cnt <= 4'd1;
            end else if (cnt < 4'd8) begin
                // Perform division step
                if (remainder[8]) begin
                    remainder <= {remainder[7:0], 1'b0} - {1'b0, divisor_reg};
                    quotient <= quotient + (1 << (cnt - 1));
                end else begin
                    remainder <= {remainder[7:0], 1'b0};
                end
                cnt <= cnt + 1;
            end else begin
                // Division complete
                result <= {remainder[7:0], quotient};
                res_valid <= 1'b1;
                start_div <= 1'b0;
            end
        end
    end
end

endmodule