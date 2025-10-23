module radix2_div (
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output res_ready,
    output reg res_valid,
    output reg [15:0] result
);

// Internal registers
reg [3:0] cnt;
reg [15:0] sr;          // Shift register [rem|quot]
reg [7:0] divisor_reg;
reg [7:0] neg_divisor;
reg signed_op;
reg processing;
reg div_by_zero;

// Handshake signals
assign res_ready = !processing && !res_valid;

// Absolute value computation
wire [7:0] abs_dividend = (sign & dividend[7]) ? -dividend : dividend;
wire [7:0] abs_divisor = (sign & divisor[7]) ? -divisor : divisor;

// Subtraction logic
wire [8:0] sub_result = {1'b0, sr[15:8]} + {1'b0, neg_divisor};
wire sub_positive = ~sub_result[8];
wire remainder_zero = (sub_result[7:0] == 0);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        result <= 0;
        cnt <= 0;
        sr <= 0;
        divisor_reg <= 0;
        neg_divisor <= 0;
        signed_op <= 0;
        processing <= 0;
        div_by_zero <= 0;
    end else begin
        // Clear valid when result is consumed
        if (res_valid && !opn_valid) begin
            res_valid <= 0;
        end
        
        // New operation start
        if (opn_valid && res_ready) begin
            div_by_zero <= (divisor == 0);
            signed_op <= sign;
            
            if (divisor == 0) begin
                // Handle divide by zero
                result <= {dividend, 8'hFF};
                res_valid <= 1;
            end else begin
                // Initialize registers
                sr <= {8'b0, abs_dividend};
                divisor_reg <= abs_divisor;
                neg_divisor <= ~abs_divisor + 1'b1;
                cnt <= 0;
                processing <= 1;
            end
        end
        
        // Division processing
        if (processing) begin
            if (cnt == 4'd8 || remainder_zero) begin
                // Finalize result
                if (signed_op) begin
                    // Apply sign correction
                    result[15:8] <= (dividend[7] ^ divisor_reg[7]) ? -sr[15:8] : sr[15:8];
                    result[7:0] <= (dividend[7] ^ divisor_reg[7]) ? -sr[7:0] : sr[7:0];
                end else begin
                    result <= {sr[15:8], sr[7:0]};
                end
                res_valid <= 1;
                processing <= 0;
            end else begin
                // Normal iteration
                if (sub_positive) begin
                    sr <= {sub_result[7:0], sr[7:0], 1'b1};
                end else begin
                    sr <= {sr[14:0], 1'b0};
                end
                cnt <= cnt + 1;
            end
        end
    end
end

endmodule