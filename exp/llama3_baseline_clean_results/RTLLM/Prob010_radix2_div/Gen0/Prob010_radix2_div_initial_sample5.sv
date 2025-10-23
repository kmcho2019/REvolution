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

reg [7:0] SR;
reg [7:0] NEG_DIVISOR;
reg [2:0] cnt;
reg start_cnt;
reg [15:0] temp_result;

always @(posedge clk) begin
    if (rst) begin
        SR <= 0;
        NEG_DIVISOR <= 0;
        cnt <= 0;
        start_cnt <= 0;
        res_valid <= 0;
    end else if (opn_valid &&!res_valid) begin
        // Save inputs and initialize registers
        if (sign) begin
            // Signed division
            SR <= {{1'b0}, {8{dividend[7]}}};
            NEG_DIVISOR <= ~({8{divisor[7]}}) + 1;
        end else begin
            // Unsigned division
            SR <= {1'b0, dividend};
            NEG_DIVISOR <= ~divisor + 1;
        end
        cnt <= 1;
        start_cnt <= 1;
        res_valid <= 0;
    end else if (start_cnt) begin
        // Division process
        if (cnt == 8) begin
            // Division complete
            cnt <= 0;
            start_cnt <= 0;
            if (sign) begin
                // Signed result
                temp_result <= {SR[8:1], SR[0]};
            end else begin
                // Unsigned result
                temp_result <= {SR[8:1], SR[0]};
            end
            res_valid <= 1;
        end else begin
            // Perform subtraction and update SR
            reg [8:0] sub_result;
            sub_result <= SR + NEG_DIVISOR;
            if (sub_result[8]) begin
                // No borrow
                SR <= {1'b0, SR[7:1]} + {8{sub_result[8]}};
            end else begin
                // Borrow
                SR <= {1'b1, SR[7:1]};
            end
            cnt <= cnt + 1;
        end
    end else if (res_valid &&!opn_valid) begin
        // Result consumed
        res_valid <= 0;
    end
end

assign result = temp_result;

endmodule