module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    // Identify present state bits
    wire y2 = y[2];
    wire y1 = y[1];
    wire y0 = y[0];

    // Decode present state conditions directly with bitwise operations:
    wire is_000 = ~y2 & ~y1 & ~y0;
    wire is_001 = ~y2 & ~y1 &  y0;
    wire is_010 = ~y2 &  y1 & ~y0;
    wire is_011 = ~y2 &  y1 &  y0;
    wire is_100 =  y2 & ~y1 & ~y0;

    // Next state bit 2 (ns2)
    // ns2=1 if (y=001 and x=1) or (y=100 and x=1)
    assign Y0 = ( (is_000 | is_010) ? x : ~x ); // Next state bit 0, which is output Y0

    wire ns2 = (is_001 & x) | (is_100 & x);

    // Next state bit 1 (ns1)
    // ns1=1 when (y=010 & x=0) or (y=011 & x=1) or (y=100 & x=0)
    wire ns1 = (is_010 & ~x) | (is_011 & x) | (is_100 & ~x);

    // Output z is high when y=011 or y=100
    assign z = is_011 | is_100;

endmodule