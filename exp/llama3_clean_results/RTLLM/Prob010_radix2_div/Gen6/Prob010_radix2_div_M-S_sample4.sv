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

reg [15:0] sr; // Shift register
reg [7:0] neg_divisor; // Negated absolute value of divisor
reg [2:0] cnt; // Counter
reg start_cnt; // Start counter signal

// Reset logic
always @(posedge clk or posedge rst) begin
    if (rst) begin
        sr <= 0;
        neg_divisor <= 0;
        cnt <= 0;
        start_cnt <= 0;
    end else if (opn_valid && !start_cnt) begin
        // Save the inputs dividend and divisor
        if (sign) begin
            // Signed division
            sr <= {dividend[7]? {8{1'b1}} : {8{1'b0}}} + {dividend, 1'b0};
            neg_divisor <= ({divisor[7]? {8{1'b1}} : {8{1'b0}}} + divisor);
        end else begin
            // Unsigned division
            sr <= {dividend, 1'b0};
            neg_divisor <= divisor;
        end
        cnt <= 1;
        start_cnt <= 1;
    end
end

// Division process
always @(posedge clk) begin
    if (start_cnt) begin
        if (cnt == 8) begin
            // Division complete
            cnt <= 0;
            start_cnt <= 0;
            result <= {sr[15:8], sr[7:0]};
        end else begin
            // Update shift register and counter
            reg [16:0] temp;
            temp = {1'b0, sr} - {1'b0, neg_divisor};
            if (temp[16]) begin
                // No borrow
                sr <= {1'b0, sr[15:1]};
            end else begin
                // Borrow
                sr <= {1'b1, sr[15:1]};
            end
            cnt <= cnt + 1;
        end
    end
end

// Assign output
assign res_valid = start_cnt && (cnt == 8);

endmodule