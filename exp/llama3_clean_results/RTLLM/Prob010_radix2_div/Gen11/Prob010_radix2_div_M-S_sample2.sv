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

reg [7:0] dividend_reg;  
reg [7:0] divisor_reg;  
reg [8:0] sr;  // Shift register to hold remainder and quotient
reg [3:0] cnt;  // Counter to control division steps
reg neg_divisor;  // Negated divisor for subtraction

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 1'b0;
        cnt <= 4'd0;
        dividend_reg <= 8'd0;
        divisor_reg <= 8'd0;
        sr <= 9'd0;
    end else if (opn_valid &&!res_valid) begin
        // Initialize registers
        dividend_reg <= (sign && dividend[7])? (~dividend + 1) : dividend;
        divisor_reg <= (sign && divisor[7])? (~divisor + 1) : divisor;
        sr <= {1'b0, dividend_reg};  // Initialize shift register
        neg_divisor <= (~divisor_reg + 1);  // Negated divisor
        cnt <= 4'd1;
        res_valid <= 1'b0;
    end else if (cnt < 4'd8) begin
        // Perform division steps
        if (sr[8]) begin
            // If most significant bit is 1, subtract divisor
            sr <= sr + neg_divisor;
        end else begin
            // Otherwise, shift left and insert 0
            sr <= {sr[7:0], 1'b0};
        end
        cnt <= cnt + 1;
    end else if (cnt == 4'd8) begin
        // Division complete, update result
        result <= {sr[8:1], sr[0]};
        res_valid <= 1'b1;
    end else if (res_valid) begin
        // Reset result validity
        res_valid <= 1'b0;
    end
end

endmodule