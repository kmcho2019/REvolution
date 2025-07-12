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

reg [15:0] sr; // Shift register
reg [7:0] neg_divisor; // Negated divisor
reg [3:0] cnt; // Counter
reg start_cnt; // Start counter signal

always @(posedge clk) begin
    if (rst) begin
        sr <= 0;
        neg_divisor <= 0;
        cnt <= 0;
        start_cnt <= 0;
        res_valid <= 0;
    end else if (opn_valid && !res_valid) begin
        sr <= {1'b0, dividend}; // Initialize shift register
        neg_divisor <= ~divisor + 1; // Calculate negated divisor
        cnt <= 1;
        start_cnt <= 1;
    end else if (start_cnt) begin
        if (cnt == 8) begin
            start_cnt <= 0;
            res_valid <= 1;
            result <= {sr[15:8], sr[7:0]}; // Form result
        end else begin
            reg [15:0] temp;
            temp = sr - {neg_divisor, 8'b0}; // Perform subtraction
            if (temp[15]) begin // Check carry-out
                sr <= {1'b0, sr[14:0]} << 1; // Shift left and insert 0
            end else begin
                sr <= {1'b1, sr[14:0]} << 1; // Shift left and insert 1
            end
            cnt <= cnt + 1;
        end
    end
end

endmodule