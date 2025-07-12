module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input  [N-1:0] a,
    input  [N-1:0] b,
    output reg [N-1:0] c
);

// Define the stages of the bitwise subtraction pipeline
reg [N-1:0] sds_result;  // Sign detection stage result
reg [N-1:0] bss_result;  // Bitwise subtraction stage result
reg [N-1:0] ras_result;  // Result adjustment stage result

// Define the control signals
reg same_sign;
reg different_sign;

// Sign detection stage
always @(a or b) begin
    if (a[N-1] == b[N-1]) begin
        same_sign = 1'b1;
        different_sign = 1'b0;
    end else begin
        same_sign = 1'b0;
        different_sign = 1'b1;
    end
end

// Bitwise subtraction stage
always @(same_sign or different_sign or a or b) begin
    if (same_sign) begin
        bss_result = a - b;
    end else if (different_sign) begin
        if (a[N-1] == 1'b0) begin
            bss_result = a + (~b + 1'b1);
        end else begin
            bss_result = (~a + 1'b1) + b;
        end
    end
end

// Result adjustment stage
always @(bss_result) begin
    if (bss_result == 0) begin
        ras_result = {N{1'b0}};
    end else if (bss_result[N-1] == 1'b1) begin
        ras_result = ~bss_result + 1'b1;
    end else begin
        ras_result = bss_result;
    end
end

// Final result
always @(ras_result) begin
    c = ras_result;
end

endmodule