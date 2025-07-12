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

wire [7:0] abs_dividend;  // Absolute value of the dividend
wire [7:0] abs_divisor;   // Absolute value of the divisor
reg [15:0] sr;           // Shift register
reg [3:0] cnt;            // Counter
reg start_div;            // Start division flag

// Combinational logic for preparing input operands
assign abs_dividend = (sign && dividend[7]) ? (~dividend + 1) : dividend;
assign abs_divisor = (sign && divisor[7]) ? (~divisor + 1) : divisor;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        sr <= 0;
        cnt <= 0;
        start_div <= 0;
        res_valid <= 0;
        result <= 0;
    end else begin
        if (~start_div && opn_valid && ~res_valid) begin
            // Start division
            sr <= {1'b0, abs_dividend};
            cnt <= 1;
            start_div <= 1;
        end else if (start_div) begin
            reg [9:0] subtract;
            subtract = {1'b0, sr[15:8]} - abs_divisor;
            if (~subtract[8]) begin
                // No borrow
                sr <= {1'b0, sr[15:8]} << 1 | 1'b1;
            end else begin
                // Borrow
                sr <= {1'b1, sr[15:8]} + (abs_divisor << 1);
            end
            cnt <= cnt + 1;
            if (cnt == 8) begin
                // End of division
                result <= {sr[15:8], sr[7:0]};
                res_valid <= 1;
                start_div <= 0;
            end
        end
        if (res_valid && ~opn_valid) begin
            // Reset result validity when operation is not valid
            res_valid <= 0;
        end
    end
end

endmodule