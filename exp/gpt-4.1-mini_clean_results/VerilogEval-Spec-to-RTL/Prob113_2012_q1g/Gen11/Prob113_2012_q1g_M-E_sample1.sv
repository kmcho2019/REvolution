module TopModule(
    input  [3:0] x,
    output       f
);

    // The Karnaugh map is indexed by row = {x[2], x[3]}, col = {x[0], x[1]}
    // Input vector is x = {x[3], x[2], x[1], x[0]} (bit3 .. bit0)
    // Need to map each input x value (0..15) to corresponding f

    // Let's list f for each x value:
    // For each x[3:0], find row and col:
    // row = {x[2], x[3]} = {x[2], x[3]}
    // col = {x[0], x[1]}
    //
    // Example: x=4'b0000 (x[3]=0,x[2]=0,x[1]=0,x[0]=0)
    // row = {x[2], x[3]} = 0,0 = 0
    // col = {x[0], x[1]} = 0,0 = 0
    // f=1 per K-map
    //
    // Let's build f values in ascending order x=0..15:
    // x   x[3] x[2] x[1] x[0] | row{x[2],x[3]} col{x[0],x[1]} | f
    // 0   0    0    0    0    | 0 0              0 0          | 1
    // 1   0    0    0    1    | 0 0              1 0          | 1
    // 2   0    0    1    0    | 0 0              0 1          | 0
    // 3   0    0    1    1    | 0 0              1 1          | 0
    // 4   0    1    0    0    | 1 0              0 0          | 1
    // 5   0    1    0    1    | 1 0              1 0          | 1
    // 6   0    1    1    0    | 1 0              0 1          | 1
    // 7   0    1    1    1    | 1 0              1 1          | 0
    // 8   1    0    0    0    | 0 1              0 0          | 0
    // 9   1    0    0    1    | 0 1              1 0          | 0
    // 10  1    0    1    0    | 0 1              0 1          | 0
    // 11  1    0    1    1    | 0 1              1 1          | 0
    // 12  1    1    0    0    | 1 1              0 0          | 1
    // 13  1    1    0    1    | 1 1              1 0          | 0
    // 14  1    1    1    0    | 1 1              0 1          | 1
    // 15  1    1    1    1    | 1 1              1 1          | 1

    // Wait, the above table was built under the assumption row = {x[2], x[3]}, col = {x[0], x[1]} 
    // But when the input is 4'babcd, bits: x[3] = a, x[2] = b, x[1] = c, x[0] = d
    // So row = {x[2], x[3]} = {b, a}
    // col = {x[0], x[1]} = {d, c}

    // Let's build the function f with respect to input 'x' as an address, where bit indices are:
    // x[3] = a (MSB), x[2] = b, x[1] = c, x[0] = d (LSB)
    // So row = {b,a}, col={d,c}

    // For each address x=a b c d, f = K-map[row={b,a}, col={d,c}]

    // Let's fill the 16-bit vector with f values for addresses 0..15, using K-map:

    // For address 0 (a=0,b=0,c=0,d=0):
    // row = {b,a} = 0 0
    // col = {d,c} = 0 0
    // f=1 (K-map[00][00]=1)

    // address order: a b c d (x[3:0])
    // map:
    // x | a b c d | row(b,a) | col(d,c) | f
    // 0 | 0 0 0 0 | 0 0      | 0 0      | 1
    // 1 | 0 0 0 1 | 0 0      | 1 0      | 1
    // 2 | 0 0 1 0 | 0 0      | 0 1      | 0
    // 3 | 0 0 1 1 | 0 0      | 1 1      | 0
    // 4 | 0 1 0 0 | 1 0      | 0 0      | 0
    // 5 | 0 1 0 1 | 1 0      | 1 0      | 0
    // 6 | 0 1 1 0 | 1 0      | 0 1      | 0
    // 7 | 0 1 1 1 | 1 0      | 1 1      | 0
    // 8 | 1 0 0 0 | 0 1      | 0 0      | 1
    // 9 | 1 0 0 1 | 0 1      | 1 0      | 1
    // 10| 1 0 1 0 | 0 1      | 0 1      | 1
    // 11| 1 0 1 1 | 0 1      | 1 1      | 0
    // 12| 1 1 0 0 | 1 1      | 0 0      | 1
    // 13| 1 1 0 1 | 1 1      | 1 0      | 0
    // 14| 1 1 1 0 | 1 1      | 0 1      | 1
    // 15| 1 1 1 1 | 1 1      | 1 1      | 1

    // Now generate 16-bit vector from MSB=address15 LSB=address0:
    // bits from MSB to LSB: f(15)f(14)...f(0)
    // f(15)=1
    // f(14)=1
    // f(13)=0
    // f(12)=1
    // f(11)=0
    // f(10)=1
    // f(9) =1
    // f(8) =1
    // f(7) =0
    // f(6) =0
    // f(5) =0
    // f(4) =0
    // f(3) =0
    // f(2) =0
    // f(1) =1
    // f(0) =1

    // binary = 16'b 1_1_0_1_0_1_1_1_0_0_0_0_0_0_1_1
    //           1 1 0 1 0 1 1 1 0 0 0 0 0 0 1 1
    // hex = 16'b 1101_0111_0000_0011 = 0xD703

    // We'll store this constant and assign f = lookup[x];

    wire [15:0] lut = 16'hD703;

    assign f = lut[x];

endmodule