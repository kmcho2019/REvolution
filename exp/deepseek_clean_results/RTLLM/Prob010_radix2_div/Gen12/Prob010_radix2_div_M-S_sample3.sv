module radix2_div (
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output reg res_valid,
    output reg [15:0] result
);

reg [3:0] cnt;        // 0-8 counter (extra bit for termination)
reg [15:0] acc;       // Accumulator: {remainder, quotient}
reg calc_active;
reg q_sign, r_sign;

// Non-restoring division step
wire [8:0] sub_result = {acc[15:8], 1'b0} + {1'b0, ~(sign & divisor[7] ? -divisor : divisor) + 1'b1};
wire carry_out = ~sub_result[8];  // 1 if result positive
wire [15:0] next_acc = carry_out ? 
    {sub_result[7:0], acc[7:0], 1'b1} : 
    {acc[14:0], 1'b0};

always @(posedge clk or posedge rst) begin
    if (rst) begin
        cnt <= 0;
        acc <= 0;
        res_valid <= 0;
        result <= 0;
        calc_active <= 0;
    end else begin
        res_valid <= 0;
        
        if (calc_active) begin
            if (cnt[3]) begin  // cnt == 8
                // Final adjustment for non-restoring
                if (acc[15]) begin
                    acc[15:8] <= acc[15:8] + (sign & divisor[7] ? -divisor : divisor);
                end
                
                // Apply signs to result
                result <= {
                    r_sign ? -acc[15:8] : acc[15:8],  // remainder
                    q_sign ? -acc[7:0] : acc[7:0]     // quotient
                };
                
                res_valid <= 1;
                calc_active <= 0;
            end else begin
                // Normal iteration
                acc <= next_acc;
                cnt <= cnt + 1;
            end
        end else if (opn_valid) begin
            // Store result signs
            r_sign <= sign & dividend[7];
            q_sign <= (sign & dividend[7]) ^ (sign & divisor[7]);
            
            // Initialize accumulator with absolute dividend
            acc <= {8'b0, sign & dividend[7] ? -dividend : dividend};
            cnt <= 0;
            calc_active <= 1;
        end
    end
end

endmodule