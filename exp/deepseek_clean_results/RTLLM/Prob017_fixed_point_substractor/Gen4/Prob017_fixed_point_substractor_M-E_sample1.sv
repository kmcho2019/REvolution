module fixed_point_subtractor #(
    parameter Q = 16,  // Fractional bits
    parameter N = 32    // Total bits
) (
    input wire clk,
    input wire rst_n,
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c,
    output reg overflow
);

// Pipeline registers
reg [N-2:0] a_mag, b_mag;
reg a_sign, b_sign;
reg [N-2:0] larger_mag, smaller_mag;
reg result_sign;
reg [N-1:0] stage2_result;
reg stage2_zero_pred;

// Stage 1: Sign-Magnitude Separation and Zero Prediction
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        a_mag <= 0;
        b_mag <= 0;
        a_sign <= 0;
        b_sign <= 0;
        stage2_zero_pred <= 0;
    end else begin
        a_sign <= a[N-1];
        b_sign <= b[N-1];
        a_mag <= a[N-2:0];
        b_mag <= b[N-2:0];
        // Early zero prediction
        stage2_zero_pred <= (a[N-2:0] == b[N-2:0]) && (a[N-1] == b[N-1]);
    end
end

// Stage 2: Magnitude Comparison and Operation Selection
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        larger_mag <= 0;
        smaller_mag <= 0;
        result_sign <= 0;
        stage2_result <= 0;
    end else begin
        if (a_mag > b_mag) begin
            larger_mag <= a_mag;
            smaller_mag <= b_mag;
            result_sign <= a_sign;
        end else begin
            larger_mag <= b_mag;
            smaller_mag <= a_mag;
            result_sign <= b_sign;
        end
        
        // Pre-compute magnitude difference
        stage2_result <= larger_mag - smaller_mag;
    end
end

// Stage 3: Result Assembly and Overflow Detection
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        c <= 0;
        overflow <= 0;
    end else begin
        if (stage2_zero_pred) begin
            c <= 0;  // Explicit zero handling
            overflow <= 0;
        end else begin
            // Check for overflow (magnitude exceeds N-1 bits)
            overflow <= (stage2_result[N-2] && (a_sign != b_sign)) ? 1'b1 : 1'b0;
            
            // Final result assembly
            if (a_sign == b_sign) begin
                c <= {result_sign, stage2_result};
            end else begin
                c <= {result_sign, stage2_result};
            end
        end
    end
end

endmodule