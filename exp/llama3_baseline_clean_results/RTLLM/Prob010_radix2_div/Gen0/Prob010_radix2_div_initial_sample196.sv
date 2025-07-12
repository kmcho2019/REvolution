module radix2_div (
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output res_valid,
    output [15:0] result
);

    reg [15:0] SR; // Shift Register
    reg [7:0] NEG_DIVISOR; // Negated absolute value of divisor
    reg [3:0] cnt; // Counter for division iterations
    reg start_cnt; // Start counter flag
    reg [15:0] abs_dividend; // Absolute value of dividend
    reg [7:0] abs_divisor; // Absolute value of divisor
    reg [15:0] temp_result; // Temporary result for formatting

    always @ (posedge clk or posedge rst) begin
        if (rst) begin
            SR <= 16'd0;
            NEG_DIVISOR <= 8'd0;
            cnt <= 4'd0;
            start_cnt <= 1'd0;
            res_valid <= 1'd0;
        end else begin
            if (opn_valid && !res_valid) begin
                // Initialize absolute values and shift register
                abs_dividend <= sign ? ({8'd0, {~dividend[7], dividend[6:0]}} + 1) : {8'd0, dividend};
                abs_divisor <= sign ? ({8'd0, {~divisor[7], divisor[6:0]}} + 1) : divisor;
                SR <= abs_dividend;
                NEG_DIVISOR <= {8'd0, {~abs_divisor[7], abs_divisor[6:0]}} + 1;
                cnt <= 4'd1;
                start_cnt <= 1'd1;
            end

            if (start_cnt) begin
                if (cnt == 8'd8) begin
                    // Division complete
                    cnt <= 4'd0;
                    start_cnt <= 1'd0;
                    // Format result
                    temp_result <= {SR[15:8], SR[7:0]};
                    if (sign && (dividend[7] != divisor[7])) begin
                        temp_result <= ({8'd0, {~temp_result[7], temp_result[6:0]}} + 1) << 8 |
                                     {~temp_result[7:0]} + 1;
                    end
                    res_valid <= 1'd1;
                end else begin
                    // Perform division
                    if (SR[15:8] >= NEG_DIVISOR) begin
                        SR <= {SR[14:0], 1'b1} - {NEG_DIVISOR, 8'd0};
                    end else begin
                        SR <= {SR[14:0], 1'b0} << 1;
                    end
                    cnt <= cnt + 1'd1;
                end
            end

            if (res_valid && !opn_valid) begin
                res_valid <= 1'd0;
            end
        end
    end

    assign result = temp_result;

endmodule