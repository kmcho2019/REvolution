module TopModule(
    input [3:0] x,
    output f
);
    // Inputs: x[3], x[2], x[1], x[0]
    // Karnaugh map variables as given:
    // Rows: x[3] x[0]
    // Columns: x[1] x[2]

    // Rewrite Karnaugh map explicitly using x[3]x[0] rows and x[1]x[2] cols:
    // Rows: 00, 01, 11, 10 (x[3]x[0])
    // Cols: 00, 01, 11, 10 (x[1]x[2])
    //
    // (row, col): value
    // (00,00): d
    // (00,01): 0
    // (00,11): d
    // (00,10): d
    //
    // (01,00): 0
    // (01,01): d
    // (01,11): 1
    // (01,10): 0
    //
    // (11,00): 1
    // (11,01): 1
    // (11,11): d
    // (11,10): d
    //
    // (10,00): 1
    // (10,01): 1
    // (10,11): 0
    // (10,10): d

    // Let's define variables for the map positions:
    // r = {x[3], x[0]}, c = {x[1], x[2]}
    wire r0 = x[3];
    wire r1 = x[0];
    wire c0 = x[1];
    wire c1 = x[2];

    // Simplify function using the Karnaugh map and available don't-cares:
    // Let's pick don't cares as 0 or 1 to get the simplest sum of products.

    // Try to group 1s:
    // 1s at:
    // (11,00): 1 -> r=11=3, c=00=0
    // (11,01): 1 -> r=3, c=1
    // (10,00): 1 -> r=2, c=0
    // (10,01): 1 -> r=2, c=1
    // (01,11): 1 -> r=1, c=3

    // Group1: (10,00), (10,01), (11,00), (11,01)
    // This is rows 2 and 3, columns 0 and 1
    // r = 1x (x[3]=1 or 0?), x[0]=0 or 1?
    // r=10 or 11 (x[3]=1), so x[3]=1
    // c=00 or 01 (x[1]=0), so x[1]=0
    // So group covers: x[3]=1 and x[1]=0

    // Group2: (01,11): r=01, c=11
    // r=0 1, c=1 1
    // x[3]=0, x[0]=1, x[1]=1, x[2]=1

    // Now check if can cover (01,11) with any don't cares, to form bigger group:
    // (01,10): 0
    // (00,11): d
    // (11,11): d
    // (10,11): 0
    // So can't group (01,11) with neighbors, must be single minterm.

    // So the function f = (x[3] & ~x[1]) | ( ~x[3] & x[0] & x[1] & x[2])

    assign f = (x[3] & ~x[1]) | (~x[3] & x[0] & x[1] & x[2]);

endmodule