module fixed_point_adder #(
    parameter Q = 8,    // Fractional bits
    parameter N = 16    // Total bits
) (
    input wire clk,
    input wire rst_n,
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c,
    output reg overflow
);

    // Stage 1 registers
    reg [N-1:0] a_stg1, b_stg1;
    reg a_sign_stg1, b_sign_stg1;
    reg [N-2:0] a_mag_stg1, b_mag_stg1;
    reg same_sign_stg1;
    
    // Stage 2 signals
    wire [N:0] sum_full;  // Extra bit for overflow detection
    wire [N-1:0] sum_sat;
    wire [N-1:0] diff;
    wire diff_sign;
    wire a_larger;
    
    // Leading zero detection for optimized comparison
    function [N-2:0] lzd;
        input [N-2:0] val;
        integer i;
        begin
            lzd = 0;
            for (i = N-2; i >= 0; i = i-1)
                if (val[i]) begin
                    lzd = i;
                    break;
                end
        end
    endfunction
    
    // Pipeline stage 1
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_stg1 <= 0;
            b_stg1 <= 0;
            a_sign_stg1 <= 0;
            b_sign_stg1 <= 0;
            a_mag_stg1 <= 0;
            b_mag_stg1 <= 0;
            same_sign_stg1 <= 0;
        end else begin
            a_stg1 <= a;
            b_stg1 <= b;
            a_sign_stg1 <= a[N-1];
            b_sign_stg1 <= b[N-1];
            a_mag_stg1 <= a[N-1] ? -a[N-2:0] : a[N-2:0];
            b_mag_stg1 <= b[N-1] ? -b[N-2:0] : b[N-2:0];
            same_sign_stg1 <= (a[N-1] == b[N-1]);
        end
    end
    
    // Magnitude comparison using leading zeros
    assign a_larger = (lzd(a_mag_stg1) > lzd(b_mag_stg1)) ? 1'b1 :
                     ((lzd(a_mag_stg1) < lzd(b_mag_stg1)) ? 1'b0 :
                     (a_mag_stg1 >= b_mag_stg1));
    
    // Arithmetic operations
    assign sum_full = {1'b0, a_mag_stg1} + {1'b0, b_mag_stg1};
    assign sum_sat = sum_full[N] ? {1'b0, {(N-1){1'b1}}} : sum_full[N-1:0];
    
    assign diff = a_larger ? (a_mag_stg1 - b_mag_stg1) : (b_mag_stg1 - a_mag_stg1);
    assign diff_sign = a_larger ? a_sign_stg1 : b_sign_stg1;
    
    // Pipeline stage 2
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            c <= 0;
            overflow <= 0;
        end else begin
            overflow <= same_sign_stg1 & sum_full[N];
            if (same_sign_stg1) begin
                c <= {a_sign_stg1, sum_sat[N-2:0]};
            end else begin
                c <= {diff_sign, diff};
            end
        end
    end

endmodule