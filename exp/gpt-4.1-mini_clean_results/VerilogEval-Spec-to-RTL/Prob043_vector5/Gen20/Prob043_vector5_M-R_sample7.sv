module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    // Pack inputs into a vector indexed [0:4] = {a,b,c,d,e} for natural order
    wire [4:0] inputs = {a, b, c, d, e};

    // Declare an intermediate 5x5 matrix storing lower triangle and diagonal XNOR results
    wire [4:0] eq_row0; // i=0 (a)
    wire [4:1] eq_row1; // i=1 (b), j >= i
    wire [4:2] eq_row2; // i=2 (c), j >= i
    wire [4:3] eq_row3; // i=3 (d), j >= i
    wire [4:4] eq_row4; // i=4 (e), j >= i

    // Compute only for j >= i
    assign eq_row0[0] = inputs[0] ~^ inputs[0]; // a~^a
    assign eq_row0[1] = inputs[0] ~^ inputs[1]; // a~^b
    assign eq_row0[2] = inputs[0] ~^ inputs[2]; // a~^c
    assign eq_row0[3] = inputs[0] ~^ inputs[3]; // a~^d
    assign eq_row0[4] = inputs[0] ~^ inputs[4]; // a~^e

    assign eq_row1[1] = inputs[1] ~^ inputs[1]; // b~^b
    assign eq_row1[2] = inputs[1] ~^ inputs[2]; // b~^c
    assign eq_row1[3] = inputs[1] ~^ inputs[3]; // b~^d
    assign eq_row1[4] = inputs[1] ~^ inputs[4]; // b~^e

    assign eq_row2[2] = inputs[2] ~^ inputs[2]; // c~^c
    assign eq_row2[3] = inputs[2] ~^ inputs[3]; // c~^d
    assign eq_row2[4] = inputs[2] ~^ inputs[4]; // c~^e

    assign eq_row3[3] = inputs[3] ~^ inputs[3]; // d~^d
    assign eq_row3[4] = inputs[3] ~^ inputs[4]; // d~^e

    assign eq_row4[4] = inputs[4] ~^ inputs[4]; // e~^e

    // Helper function to get eq(i,j) with symmetric reuse
    function logic eq(input int i, input int j);
        if (i <= j)
            case(i)
                0: eq = eq_row0[j];
                1: eq = eq_row1[j];
                2: eq = eq_row2[j];
                3: eq = eq_row3[j];
                4: eq = eq_row4[j];
                default: eq = 1'b0; // shouldn't happen
            endcase
        else
            eq = eq(j, i);
    endfunction

    // Assign out bits: bit position = 24 - (i*5 + j)
    // i,j from 0 to 4 corresponding to inputs a=0,...,e=4
    assign out[24] = eq(0,0);  // a~^a
    assign out[23] = eq(0,1);  // a~^b
    assign out[22] = eq(0,2);
    assign out[21] = eq(0,3);
    assign out[20] = eq(0,4);

    assign out[19] = eq(1,0);
    assign out[18] = eq(1,1);
    assign out[17] = eq(1,2);
    assign out[16] = eq(1,3);
    assign out[15] = eq(1,4);

    assign out[14] = eq(2,0);
    assign out[13] = eq(2,1);
    assign out[12] = eq(2,2);
    assign out[11] = eq(2,3);
    assign out[10] = eq(2,4);

    assign out[9]  = eq(3,0);
    assign out[8]  = eq(3,1);
    assign out[7]  = eq(3,2);
    assign out[6]  = eq(3,3);
    assign out[5]  = eq(3,4);

    assign out[4]  = eq(4,0);
    assign out[3]  = eq(4,1);
    assign out[2]  = eq(4,2);
    assign out[1]  = eq(4,3);
    assign out[0]  = eq(4,4);  // e~^e

endmodule