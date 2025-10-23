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

reg [7:0] sr;  // Shift register
reg [7:0] neg_divisor;  // Negated absolute value of divisor
reg [2:0] cnt;  // Counter for division steps
reg start_cnt;  // Flag to indicate division start
reg [15:0] temp_result;  // Temporary result register

// Initialize shift register and counter when opn_valid is high and res_valid is low
always @(posedge clk) begin
    if (rst) begin
        sr <= 8'b0;
        neg_divisor <= 8'b0;
        cnt <= 3'b0;
        start_cnt <= 1'b0;
        res_valid <= 1'b0;
    end else if (opn_valid && !res_valid) begin
        if (sign) begin
            // Signed division
            if (dividend[7]) begin
                sr <= {1'b1, ~dividend[7:0]} + 1;
            end else begin
                sr <= {1'b0, dividend[7:0]};
            end
            if (divisor[7]) begin
                neg_divisor <= ~divisor[7:0] + 1;
            end else begin
                neg_divisor <= {8{~divisor[7]}};
            end
        end else begin
            // Unsigned division
            sr <= {1'b0, dividend[7:0]};
            neg_divisor <= {8{~divisor[7]}};
        end
        cnt <= 3'b001;
        start_cnt <= 1'b1;
    end
end

// Division process
always @(posedge clk) begin
    if (start_cnt) begin
        if (cnt == 3'b100) begin
            // Division complete, update result
            temp_result <= {sr[7:0], sr[15:8]};
            res_valid <= 1'b1;
            cnt <= 3'b0;
            start_cnt <= 1'b0;
        end else begin
            // Perform division step
            reg [8:0] temp;
            temp <= sr[15:8] - neg_divisor;
            if (temp[8]) begin
                // Borrow occurred, update shift register
                sr <= {1'b1, sr[14:0]};
            end else begin
                // No borrow, update shift register
                sr <= {1'b0, sr[14:0]};
            end
            cnt <= cnt + 1;
        end
    end
end

// Result validity management
always @(posedge clk) begin
    if (rst) begin
        res_valid <= 1'b0;
    end else if (res_valid && !opn_valid) begin
        res_valid <= 1'b0;
    end
end

assign result = temp_result;

endmodule