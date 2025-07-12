module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Booth encoding: Radix-4 (groups of 3 bits)
    wire [8:0] booth_pp [3:0];
    wire [2:0] booth_sel [3:0];
    
    // Generate Booth encoded partial products
    assign booth_sel[0] = {B[1:0], 1'b0};
    assign booth_sel[1] = B[3:1];
    assign booth_sel[2] = B[5:3];
    assign booth_sel[3] = B[7:5];
    
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : booth_pp_gen
            // Booth encoding logic
            wire neg, dbl, zero;
            assign {neg, dbl, zero} = 
                (booth_sel[i] == 3'b000 || booth_sel[i] == 3'b111) ? 3'b000 : // 0
                (booth_sel[i] == 3'b001 || booth_sel[i] == 3'b010) ? 3'b010 : // +1
                (booth_sel[i] == 3'b101 || booth_sel[i] == 3'b110) ? 3'b110 : // -1
                3'b011; // +2 or -2
            
            wire [8:0] pp_raw = dbl ? {A, 1'b0} : {1'b0, A};
            wire [8:0] pp_neg = neg ? ~pp_raw + 1'b1 : pp_raw;
            
            // Properly shifted partial products (9 bits each)
            assign booth_pp[i] = (zero ? 9'b0 : pp_neg) << (2*i);
        end
    endgenerate

    // First level of carry-save addition
    wire [15:0] sum_l1, carry_l1;
    assign {carry_l1[14:0], sum_l1[15:2]} = 
        ({7'b0, booth_pp[0]} + {5'b0, booth_pp[1], 2'b0}) + 
        {3'b0, booth_pp[2], 4'b0};
    assign sum_l1[1:0] = booth_pp[0][1:0];
    assign carry_l1[15] = 1'b0;

    // Final addition (carry-propagate)
    assign product = sum_l1 + {carry_l1[14:0], 1'b0} + {11'b0, booth_pp[3], 6'b0};

endmodule