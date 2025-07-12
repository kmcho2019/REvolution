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
reg [15:0] shift_reg;
reg [3:0] cnt;
reg start;
reg [7:0] neg_divisor;

always @(posedge clk) begin
    if (rst) begin
        res_valid <= 0;
        start <= 0;
        cnt <= 0;
        shift_reg <= 0;
    end else begin
        if (!start && opn_valid) begin
            // Initialize registers
            dividend_reg <= sign ? {{7{dividend[7]}}, dividend[7:0]} : {8'b0, dividend};
            divisor_reg <= divisor;
            neg_divisor <= ~divisor_reg + 1; // Two's complement
            shift_reg <= {1'b0, dividend_reg}; // Initialize shift register
            cnt <= 1; // Initialize counter
            start <= 1; // Start division
        end else if (start) begin
            if (cnt == 8) begin
                // Division complete, output result
                result <= {shift_reg[15:8], shift_reg[7:0]};
                res_valid <= 1;
                start <= 0;
            end else begin
                // Perform subtraction and update shift register
                if (shift_reg[15:8] >= divisor_reg) begin
                    shift_reg <= {shift_reg[15:8] - divisor_reg, 1'b1, shift_reg[7:1]};
                end else begin
                    shift_reg <= {shift_reg[15:8], 1'b0, shift_reg[7:1]};
                end
                cnt <= cnt + 1; // Increment counter
            end
        end
        // Manage result validity
        if (rst || (!opn_valid && res_valid)) begin
            res_valid <= 0;
        end
    end
end

endmodule