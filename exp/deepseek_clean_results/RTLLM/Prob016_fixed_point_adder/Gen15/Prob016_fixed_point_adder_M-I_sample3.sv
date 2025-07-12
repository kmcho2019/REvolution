module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Parameter validation
    initial begin
        if (Q >= N) begin
            $error("Q (%0d) must be less than N (%0d)", Q, N);
        end
        if (N < 2) begin
            $error("N (%0d) must be at least 2", N);
        end
    end

    // Sign and magnitude decomposition
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-2:0] a_mag = a[N-2:0];
    wire [N-2:0] b_mag = b[N-2:0];

    // Carry-lookahead magnitude comparison
    wire a_gt_b;
    generate
        if (N <= 8) begin : fast_compare
            assign a_gt_b = (a_mag > b_mag);
        end else begin : cla_compare
            // 4-bit carry-lookahead blocks for better timing
            wire [N/4:0] carry;
            assign carry[0] = 1'b0;
            
            genvar i;
            for (i = 0; i < N-1; i=i+4) begin : compare_block
                localparam high = (i+3 > N-2) ? N-2 : i+3;
                wire [3:0] a_seg = a_mag[high -: 4];
                wire [3:0] b_seg = b_mag[high -: 4];
                
                assign carry[i/4+1] = (a_seg > b_seg) ? 1'b1 :
                                     ((a_seg == b_seg) ? carry[i/4] : 1'b0);
            end
            assign a_gt_b = carry[(N-1)/4];
        end
    endgenerate

    wire signs_equal = ~(a_sign ^ b_sign);

    // Shared arithmetic unit with clock gating
    reg [N-1:0] arith_result;
    reg result_sign;
    wire clk_en = 1'b1;  // In real implementation, connect to clock gating control
    
    always @(*) if (clk_en) begin
        if (signs_equal) begin
            arith_result = {1'b0, a_mag} + {1'b0, b_mag};
            result_sign = a_sign;
        end else begin
            if (a_gt_b) begin
                arith_result = {1'b0, a_mag} - {1'b0, b_mag};
                result_sign = a_sign;
            end else begin
                arith_result = {1'b0, b_mag} - {1'b0, a_mag};
                result_sign = b_sign;
            end
        end
    end

    // Overflow detection and saturation
    wire overflow = signs_equal & arith_result[N-1];
    wire [N-1:0] saturated = result_sign ? {1'b1, {(N-1){1'b0}}} : 
                                           {1'b0, {(N-1){1'b1}}};

    // Final output
    assign c = overflow ? saturated : {result_sign, arith_result[N-2:0]};

endmodule