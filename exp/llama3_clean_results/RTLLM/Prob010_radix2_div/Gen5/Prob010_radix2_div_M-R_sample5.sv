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

reg [8:0] sr;  // shift register with 1 extra bit for carry
reg [7:0] neg_divisor;  // negated absolute value of divisor
reg [3:0] cnt;  // counter
reg start_div;  // flag to start division
reg [7:0] quotient;  // quotient
reg [7:0] remainder;  // remainder

// Combinational logic
assign neg_divisor = (divisor[7]? ~divisor + 1 : divisor);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        sr <= 0;
        cnt <= 0;
        start_div <= 0;
        res_valid <= 0;
        result <= 0;
        quotient <= 0;
        remainder <= 0;
    end else begin
        if (opn_valid && !res_valid) begin
            // Save inputs and initialize registers
            if (sign) begin
                // Signed division
                sr <= {1'b0, (dividend[7]? ~dividend + 1 : dividend)};  // shift left by one bit
            end else begin
                // Unsigned division
                sr <= {1'b0, dividend};  // shift left by one bit
            end
            cnt <= 1;
            start_div <= 1;
        end else if (start_div) begin
            // Division process
            if (cnt == 8) begin
                // Division complete
                start_div <= 0;
                remainder <= sr[7:0];
                quotient <= sr[8];
                result <= {remainder, quotient};
                res_valid <= 1;
            end else begin
                // Update shift register
                if (sr[8] == 0) begin
                    if (sr[7:0] >= neg_divisor) begin
                        sr <= {1'b0, sr[7:0] - neg_divisor} << 1;  // shift left and insert carry-out
                    end else begin
                        sr <= {1'b1, sr[7:0]} << 1;  // shift left and insert carry-out
                    end
                end else begin
                    if ({sr[8], sr[7:0]} >= {1'b0, neg_divisor}) begin
                        sr <= {1'b0, sr[7:0] - neg_divisor} << 1;  // shift left and insert carry-out
                    end else begin
                        sr <= {1'b1, sr[7:0]} << 1;  // shift left and insert carry-out
                    end
                end
                cnt <= cnt + 1;
            end
        end else if (!opn_valid && res_valid) begin
            // Reset result validity
            res_valid <= 0;
        end
    end
end

endmodule