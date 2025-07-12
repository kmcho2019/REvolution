module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [7:0] odd
);

    // Handle division by zero case
    wire zero_divisor = (B == 8'b0);
    
    // Generate all possible shifted versions of B (16 possibilities)
    wire [23:0] shifted_B [0:15];
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : shift_gen
            assign shifted_B[i] = {16'b0, B} << i;
        end
    endgenerate

    // Parallel comparison - find all positions where shifted_B <= A
    wire [15:0] valid_positions;
    generate
        for (i = 0; i < 16; i = i + 1) begin : comp_gen
            assign valid_positions[i] = (shifted_B[i][23:8] <= A) && !zero_divisor;
        end
    endgenerate

    // Priority encoder to find maximum valid shift position
    wire [3:0] max_shift;
    assign max_shift = 
        valid_positions[15] ? 4'd15 :
        valid_positions[14] ? 4'd14 :
        valid_positions[13] ? 4'd13 :
        valid_positions[12] ? 4'd12 :
        valid_positions[11] ? 4'd11 :
        valid_positions[10] ? 4'd10 :
        valid_positions[9]  ? 4'd9  :
        valid_positions[8]  ? 4'd8  :
        valid_positions[7]  ? 4'd7  :
        valid_positions[6]  ? 4'd6  :
        valid_positions[5]  ? 4'd5  :
        valid_positions[4]  ? 4'd4  :
        valid_positions[3]  ? 4'd3  :
        valid_positions[2]  ? 4'd2  :
        valid_positions[1]  ? 4'd1  :
        valid_positions[0]  ? 4'd0  : 4'd0;

    // Calculate quotient (one-hot to binary)
    wire [15:0] quotient_onehot;
    assign quotient_onehot = (1 << max_shift);
    
    // Calculate remainder
    wire [15:0] subtracted;
    assign subtracted = A - shifted_B[max_shift][23:8];
    
    // Final outputs
    assign result = zero_divisor ? 16'b0 : quotient_onehot;
    assign odd = zero_divisor ? A[7:0] : subtracted[7:0];

endmodule