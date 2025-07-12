module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input wire clk,        // Clock for pipelining
    input wire rst_n,      // Active-low reset
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c   // Registered output
);

    // Parameter validation
    initial begin
        if (Q >= N) $error("Q must be less than N");
        if (N < 2) $error("N must be at least 2");
    end

    // Pipeline stage signals
    reg [N-1:0] a_reg, b_reg;
    reg a_sign_reg, b_sign_reg;
    reg [N-2:0] a_mag_reg, b_mag_reg;
    reg comp_reg;
    
    // Main processing
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_reg <= 0;
            b_reg <= 0;
            a_sign_reg <= 0;
            b_sign_reg <= 0;
            a_mag_reg <= 0;
            b_mag_reg <= 0;
            comp_reg <= 0;
            c <= 0;
        end else begin
            // Stage 1: Register inputs and pre-compute
            a_reg <= a;
            b_reg <= b;
            a_sign_reg <= a[N-1];
            b_sign_reg <= b[N-1];
            a_mag_reg <= a[N-2:0];
            b_mag_reg <= b[N-2:0];
            comp_reg <= (a[N-2:0] > b[N-2:0]);
            
            // Stage 2: Compute result
            if (a_sign_reg == b_sign_reg) begin
                // Same signs - add magnitudes
                c <= {a_sign_reg, a_mag_reg + b_mag_reg};
            end else if (comp_reg) begin
                // Different signs, |a| > |b|
                c <= {a_sign_reg, a_mag_reg - b_mag_reg};
            end else begin
                // Different signs, |b| > |a|
                c <= {b_sign_reg, b_mag_reg - a_mag_reg};
            end
        end
    end

endmodule