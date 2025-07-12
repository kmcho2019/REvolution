module fixed_point_subtractor #(
    parameter N = 32,        // Total bits (integer + fractional)
    parameter Q = 16         // Fractional bits (Q <= N-1)
) (
    input wire clk,          // Clock for pipelining
    input wire rst_n,        // Active-low reset
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

    // Stage 1 Registers
    reg a_sign, b_sign;
    reg [N-2:0] a_mag, b_mag;
    reg signs_equal;
    reg a_larger;
    reg is_zero;

    // Stage 2 Signals
    wire [N-2:0] mag_result;
    wire result_sign;

    // Stage 1: Sign/Magnitude Separation and Comparison
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_sign <= 1'b0;
            b_sign <= 1'b0;
            a_mag <= {(N-1){1'b0}};
            b_mag <= {(N-1){1'b0}};
            signs_equal <= 1'b0;
            a_larger <= 1'b0;
            is_zero <= 1'b0;
        end else begin
            a_sign <= a[N-1];
            b_sign <= b[N-1];
            a_mag <= a[N-2:0];
            b_mag <= b[N-2:0];
            signs_equal <= (a[N-1] == b[N-1]);
            a_larger <= (a[N-2:0] > b[N-2:0]);
            is_zero <= (a[N-2:0] == b[N-2:0]);
        end
    end

    // Stage 2: Magnitude Operation
    assign mag_result = signs_equal ? (a_mag - b_mag) : (a_mag + b_mag);
    assign result_sign = is_zero ? 1'b0 : 
                        (signs_equal ? a_sign : 
                        (a_larger ? a_sign : b_sign));

    // Output Stage
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            c <= {N{1'b0}};
        end else begin
            c <= {result_sign, mag_result};
        end
    end

endmodule