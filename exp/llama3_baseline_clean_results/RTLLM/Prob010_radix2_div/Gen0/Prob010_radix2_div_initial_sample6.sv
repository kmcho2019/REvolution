module radix2_div(
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output res_valid,
    output [15:0] result
);

reg [7:0] SR; // Shift Register
reg [7:0] NEG_DIVISOR; // Negated absolute value of divisor
reg [3:0] cnt; // Counter
reg start_cnt; // Flag to start division process
reg [15:0] final_result; // Final result

// Determine whether the operation is signed or unsigned
wire [7:0] abs_dividend = sign ? {~dividend[7], dividend[6:0]} + 1 : dividend;
wire [7:0] abs_divisor = sign ? {~divisor[7], divisor[6:0]} + 1 : divisor;

// Update NEG_DIVISOR
always @(posedge clk) begin
    if (rst) begin
        NEG_DIVISOR <= 0;
    end else if (opn_valid && !res_valid) begin
        NEG_DIVISOR <= ~abs_divisor + 1;
    end
end

// Update start_cnt and cnt
always @(posedge clk) begin
    if (rst) begin
        start_cnt <= 0;
        cnt <= 0;
    end else if (opn_valid && !res_valid) begin
        start_cnt <= 1;
        cnt <= 1;
    end else if (start_cnt) begin
        if (cnt == 8) begin
            start_cnt <= 0;
            cnt <= 0;
        end else begin
            cnt <= cnt + 1;
        end
    end
end

// Update SR
always @(posedge clk) begin
    if (rst) begin
        SR <= 0;
    end else if (opn_valid && !res_valid) begin
        SR <= {1'b0, abs_dividend};
    end else if (start_cnt) begin
        wire [8:0] sub_result = {1'b0, SR[7:0]} - {NEG_DIVISOR, 1'b0};
        SR <= {sub_result[8], sub_result[7:1]};
    end
end

// Update final result
always @(posedge clk) begin
    if (rst) begin
        final_result <= 0;
    end else if (!start_cnt && cnt == 0) begin
        final_result <= {SR[7:0], SR[7:0]};
    end
end

// Update result valid signal
always @(posedge clk) begin
    if (rst) begin
        res_valid <= 0;
    end else if (opn_valid && !res_valid) begin
        res_valid <= 0;
    end else if (!start_cnt && cnt == 0) begin
        res_valid <= 1;
    end else if (res_valid) begin
        res_valid <= 0;
    end
end

// Assign final result to output
assign result = final_result;

endmodule