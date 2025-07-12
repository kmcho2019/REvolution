module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    // Pack inputs into a vector: inputs[4]=a, ..., inputs[0]=e
    wire [4:0] inputs = {a, b, c, d, e};

    // Declare wires for upper-triangle and diagonal XNOR computations (i ≤ j)
    wire [14:0] upper_eq; // Number of elements in upper triangle including diagonal = 5 + 4 + 3 + 2 + 1 = 15

    // Map (i,j) with i≤j to an index in upper_eq for convenience:
    // index = (i*11) - (i*(i-1)/2) + (j - i)
    // For i=0..4, j=i..4
    // Indices:
    // i=0: j=0..4 => upper_eq[0..4]
    // i=1: j=1..4 => upper_eq[5..8]
    // i=2: j=2..4 => upper_eq[9..11]
    // i=3: j=3..4 => upper_eq[12..13]
    // i=4: j=4    => upper_eq[14]

    // Compute upper triangle equality bits
    assign upper_eq[ 0] = ~(inputs[4 - 0] ^ inputs[4 - 0]); // a vs a
    assign upper_eq[ 1] = ~(inputs[4 - 0] ^ inputs[4 - 1]); // a vs b
    assign upper_eq[ 2] = ~(inputs[4 - 0] ^ inputs[4 - 2]); // a vs c
    assign upper_eq[ 3] = ~(inputs[4 - 0] ^ inputs[4 - 3]); // a vs d
    assign upper_eq[ 4] = ~(inputs[4 - 0] ^ inputs[4 - 4]); // a vs e

    assign upper_eq[ 5] = ~(inputs[4 - 1] ^ inputs[4 - 1]); // b vs b
    assign upper_eq[ 6] = ~(inputs[4 - 1] ^ inputs[4 - 2]); // b vs c
    assign upper_eq[ 7] = ~(inputs[4 - 1] ^ inputs[4 - 3]); // b vs d
    assign upper_eq[ 8] = ~(inputs[4 - 1] ^ inputs[4 - 4]); // b vs e

    assign upper_eq[ 9] = ~(inputs[4 - 2] ^ inputs[4 - 2]); // c vs c
    assign upper_eq[10] = ~(inputs[4 - 2] ^ inputs[4 - 3]); // c vs d
    assign upper_eq[11] = ~(inputs[4 - 2] ^ inputs[4 - 4]); // c vs e

    assign upper_eq[12] = ~(inputs[4 - 3] ^ inputs[4 - 3]); // d vs d
    assign upper_eq[13] = ~(inputs[4 - 3] ^ inputs[4 - 4]); // d vs e

    assign upper_eq[14] = ~(inputs[4 - 4] ^ inputs[4 - 4]); // e vs e

    // Helper function to convert (i,j) with i ≤ j to upper_eq index
    function automatic int upper_idx(input int i, input int j);
        int base;
        begin
            // Number of upper_eq elements before row i = sum_{k=0}^{i-1} (5 - k) = 5*i - (i*(i-1))/2
            base = 5 * i - (i * (i - 1)) / 2;
            upper_idx = base + (j - i);
        end
    endfunction

    // Assign output bits using symmetry:
    // out[24 - (5*i + j)] corresponds to inputs[i], inputs[j]
    // If i ≤ j: assign from upper_eq
    // Else (i > j): assign from symmetric bit out[24 - (5*j + i)]

    // Explicit assignments for all 25 bits:
    // i=0 (a)
    assign out[24] = upper_eq[upper_idx(0,0)]; // a vs a
    assign out[23] = upper_eq[upper_idx(0,1)]; // a vs b
    assign out[22] = upper_eq[upper_idx(0,2)]; // a vs c
    assign out[21] = upper_eq[upper_idx(0,3)]; // a vs d
    assign out[20] = upper_eq[upper_idx(0,4)]; // a vs e

    // i=1 (b)
    assign out[19] = out[23]; // b vs a = a vs b
    assign out[18] = upper_eq[upper_idx(1,1)]; // b vs b
    assign out[17] = upper_eq[upper_idx(1,2)]; // b vs c
    assign out[16] = upper_eq[upper_idx(1,3)]; // b vs d
    assign out[15] = upper_eq[upper_idx(1,4)]; // b vs e

    // i=2 (c)
    assign out[14] = out[22]; // c vs a = a vs c
    assign out[13] = out[17]; // c vs b = b vs c
    assign out[12] = upper_eq[upper_idx(2,2)]; // c vs c
    assign out[11] = upper_eq[upper_idx(2,3)]; // c vs d
    assign out[10] = upper_eq[upper_idx(2,4)]; // c vs e

    // i=3 (d)
    assign out[9]  = out[21]; // d vs a = a vs d
    assign out[8]  = out[16]; // d vs b = b vs d
    assign out[7]  = out[11]; // d vs c = c vs d
    assign out[6]  = upper_eq[upper_idx(3,3)]; // d vs d
    assign out[5]  = upper_eq[upper_idx(3,4)]; // d vs e

    // i=4 (e)
    assign out[4]  = out[20]; // e vs a = a vs e
    assign out[3]  = out[15]; // e vs b = b vs e
    assign out[2]  = out[10]; // e vs c = c vs e
    assign out[1]  = out[5];  // e vs d = d vs e
    assign out[0]  = upper_eq[upper_idx(4,4)]; // e vs e

endmodule