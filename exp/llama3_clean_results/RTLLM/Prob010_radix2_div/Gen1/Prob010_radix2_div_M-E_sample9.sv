module radix2_div_lut(
    input  clk,
    input  rst,
    input  sign,
    input  [7:0] dividend,
    input  [7:0] divisor,
    input  opn_valid,
    output res_valid,
    output [15:0] result
);

// Define the Lookup Table (LUT) for small divisor values
reg [15:0] lut[16]; // LUT to store precomputed division results

// Initialize the LUT with precomputed division results
initial begin
    for (int i = 0; i < 16; i++) begin
        lut[i] = {8'd0, 8'd(i)}; // Precompute division results for small divisor values
    end
end

// Control and Multiplexing Logic
reg [15:0] lut_result; // Result from the LUT
reg [15:0] iter_result; // Result from the iterative division module
reg use_lut; // Flag to indicate whether to use the LUT or iterative division

// Iterative Division Module
reg [7:0] dividend_abs; // Absolute value of the dividend
reg [7:0] divisor_abs; // Absolute value of the divisor
reg [3:0] cnt; // Counter for the iterative division process
reg start_cnt; // Flag to start the iterative division process
reg [15:0] SR; // Shift register for the iterative division process
reg [7:0] NEG_DIVISOR; // Negated absolute value of the divisor

always @(posedge clk or posedge rst) begin
    if(rst) begin
        res_valid <= 0;
        use_lut <= 0;
        cnt <= 0;
        start_cnt <= 0;
        SR <= 0;
        NEG_DIVISOR <= 0;
    end else begin
        if(opn_valid &&!res_valid) begin
            // Determine whether to use the LUT or iterative division
            if(divisor < 16) begin
                use_lut <= 1;
                lut_result <= lut[divisor];
            end else begin
                use_lut <= 0;
                // Initialize the iterative division process
                dividend_abs <= (sign)? {8{dividend[7]}} ^ dividend + (dividend[7]? 8'd1 : 8'd0) : dividend;
                divisor_abs <= (sign)? {8{divisor[7]}} ^ divisor + (divisor[7]? 8'd1 : 8'd0) : divisor;
                NEG_DIVISOR <= (sign)? ~divisor_abs + 1 : divisor_abs;
                SR <= {1'b0, dividend_abs};
                cnt <= 1;
                start_cnt <= 1;
            end
        end

        if(start_cnt) begin
            if(cnt == 8) begin
                // Iterative division process complete
                start_cnt <= 0;
                res_valid <= 1;
                iter_result <= {SR[15:8], SR[7:0]};
            end else begin
                // Perform iterative division step
                if(SR[15:8] >= NEG_DIVISOR) begin
                    SR <= (SR[15:8] - NEG_DIVISOR) << 8 | SR[7:0] | 1'b1;
                end else begin
                    SR <= SR << 1;
                end
                cnt <= cnt + 1;
            end
        end

        // Multiplex the result based on the use_lut flag
        if(use_lut) begin
            result <= lut_result;
        end else begin
            result <= iter_result;
        end
    end
end

endmodule