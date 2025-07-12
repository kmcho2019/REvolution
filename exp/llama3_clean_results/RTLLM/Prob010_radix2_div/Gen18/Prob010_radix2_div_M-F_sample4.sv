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
reg signed_div;

// Initialize variables
always @(posedge clk) begin
    if (rst) begin
        dividend_reg <= 0;
        divisor_reg <= 0;
        shift_reg <= 0;
        cnt <= 0;
        start <= 0;
        res_valid <= 0;
        neg_divisor <= 0;
        signed_div <= 0;
    end else if (opn_valid && !res_valid) begin
        // Calculate absolute values
        dividend_reg <= sign ? {{7{dividend[7]}}, dividend[7:0]} : dividend;
        divisor_reg <= divisor;
        
        // Determine if division is signed
        signed_div <= sign ? 1 : 0;
        
        // Initialize shift register
        shift_reg <= {1'b0, dividend_reg};
        
        // Initialize counter and start signal
        cnt <= 1;
        start <= 1;
        
        // Calculate NEG_DIVISOR
        if (divisor[7] == 1) begin
            neg_divisor <= ~divisor + 1;
        end else begin
            neg_divisor <= divisor;
        end
    end
end

// Perform division
always @(posedge clk) begin
    if (start) begin
        if (cnt == 8) begin
            // Finalize result and set res_valid
            if (signed_div) begin
                result <= {{8{shift_reg[15]}}, shift_reg[7:0]};
            end else begin
                result <= {shift_reg[15:8], shift_reg[7:0]};
            end
            start <= 0;
            res_valid <= 1;
        end else begin
            if (shift_reg[15:8] >= divisor_reg) begin
                shift_reg <= {shift_reg[15:8] - divisor_reg, 1'b1, shift_reg[7:1]};
            end else begin
                shift_reg <= {shift_reg[15:8], 1'b0, shift_reg[7:1]};
            end
            cnt <= cnt + 1;
        end
    end else begin
        res_valid <= 0;
    end
end

// No external assign statement needed as res_valid is updated within the always block

endmodule