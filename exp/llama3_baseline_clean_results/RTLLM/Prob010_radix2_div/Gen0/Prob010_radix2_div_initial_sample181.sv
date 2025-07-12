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

reg [7:0] SR; // Shift Register
reg [2:0] cnt; // Counter
reg start_cnt; // Start Counter Flag
reg [7:0] NEG_DIVISOR; // Negated Absolute Value of Divisor
reg [7:0] ABS_DIVIDEND; // Absolute Value of Dividend
reg [7:0] quotient; // Quotient
reg [7:0] remainder; // Remainder

// Internal wires
wire [7:0] sub_result; // Subtraction result
wire cout; // Carry-out

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        cnt <= 0;
        start_cnt <= 0;
        result <= 0;
    end else if (opn_valid && !res_valid) begin
        // Save inputs and initialize registers
        ABS_DIVIDEND <= (sign) ? {~dividend[7], dividend[6:0]} + 1 : dividend;
        NEG_DIVISOR <= (sign) ? {~divisor[7], divisor[6:0]} + 1 : divisor;
        SR <= {1'b0, ABS_DIVIDEND};
        cnt <= 1;
        start_cnt <= 1;
    end else if (start_cnt) begin
        // Division process
        if (cnt == 8) begin
            // Division complete
            cnt <= 0;
            start_cnt <= 0;
            res_valid <= 1;
            result <= {remainder, quotient};
        end else begin
            // Perform subtraction and update shift register
            sub_result <= SR[7:0] - NEG_DIVISOR;
            cout <= (SR[7:0] < NEG_DIVISOR);
            SR <= {cout, sub_result};
            quotient <= quotient + {7'b0, cout};
            remainder <= sub_result;
            cnt <= cnt + 1;
        end
    end else if (res_valid && !opn_valid) begin
        // Reset result validity
        res_valid <= 0;
    end
end

endmodule