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

reg [7:0] neg_divisor;
reg [15:0] sr;
reg [2:0] cnt;
reg start_cnt;
reg [15:0] temp_result;

// Save inputs and initialize registers
always @(posedge clk) begin
    if (rst) begin
        cnt <= 0;
        start_cnt <= 0;
        sr <= 0;
        neg_divisor <= 0;
        res_valid <= 0;
    end else if (opn_valid && !res_valid) begin
        // Save inputs
        if (sign) begin
            // Signed division
            if (dividend[7]) begin
                sr <= {1'b1, ~dividend[7:0]} + 1;
            end else begin
                sr <= {1'b0, dividend};
            end
            if (divisor[7]) begin
                neg_divisor <= {1'b1, ~divisor[7:0]} + 1;
            end else begin
                neg_divisor <= {1'b0, divisor};
            end
        end else begin
            // Unsigned division
            sr <= {1'b0, dividend};
            neg_divisor <= {1'b0, divisor};
        end
        cnt <= 1;
        start_cnt <= 1;
        res_valid <= 0;
    end else if (start_cnt) begin
        // Perform division
        if (cnt == 8) begin
            // Division complete
            cnt <= 0;
            start_cnt <= 0;
            temp_result <= sr;
            res_valid <= 1;
        end else begin
            // Update shift register
            if (sr[15:8] >= neg_divisor) begin
                sr <= {sr[15:8] - neg_divisor, sr[7:0], 1'b1};
            end else begin
                sr <= {sr[15:8], sr[7:0], 1'b0};
            end
            cnt <= cnt + 1;
        end
    end
end

// Manage result validity
always @(posedge clk) begin
    if (rst) begin
        res_valid <= 0;
    end else if (res_valid && !opn_valid) begin
        res_valid <= 0;
    end
end

// Output result
assign result = temp_result;

endmodule