module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Booth encoder outputs (Radix-4)
    wire [8:0] booth_sel [3:0];
    wire [8:0] A_ext = {A[7], A};  // Sign-extended A
    wire [8:0] A_neg = ~A_ext + 1; // -A
    wire [8:0] A_2x = {A_ext[7:0], 1'b0}; // 2A
    
    // Generate Booth encoded partial products
    assign booth_sel[0] = (B[1:0] == 2'b01) ? A_ext :
                         (B[1:0] == 2'b10) ? A_neg :
                         9'b0;
    assign booth_sel[1] = (B[3:1] == 3'b001 || B[3:1] == 3'b010) ? A_ext :
                         (B[3:1] == 3'b101 || B[3:1] == 3'b110) ? A_neg :
                         (B[3:1] == 3'b011) ? A_2x :
                         (B[3:1] == 3'b100) ? {A_neg[7:0], 1'b0} :
                         9'b0;
    assign booth_sel[2] = (B[5:3] == 3'b001 || B[5:3] == 3'b010) ? A_ext :
                         (B[5:3] == 3'b101 || B[5:3] == 3'b110) ? A_neg :
                         (B[5:3] == 3'b011) ? A_2x :
                         (B[5:3] == 3'b100) ? {A_neg[7:0], 1'b0} :
                         9'b0;
    assign booth_sel[3] = (B[7:5] == 3'b001 || B[7:5] == 3'b010) ? A_ext :
                         (B[7:5] == 3'b101 || B[7:5] == 3'b110) ? A_neg :
                         (B[7:5] == 3'b011) ? A_2x :
                         (B[7:5] == 3'b100) ? {A_neg[7:0], 1'b0} :
                         9'b0;

    // Sign extension for partial products
    wire [15:0] pp0 = {{7{booth_sel[0][8]}}, booth_sel[0]};
    wire [15:0] pp1 = {{5{booth_sel[1][8]}}, booth_sel[1], 2'b0};
    wire [15:0] pp2 = {{3{booth_sel[2][8]}}, booth_sel[2], 4'b0};
    wire [15:0] pp3 = {booth_sel[3][8], booth_sel[3], 6'b0};

    // Carry-Save Adder stages
    wire [15:0] sum0, carry0;
    assign {carry0, sum0} = pp0 + pp1 + pp2;
    
    // Final addition (Carry-Propagate Adder)
    assign product = sum0 + (carry0 << 1) + pp3;

endmodule