module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    // Decode present state y into one-hot signals
    wire s0 = (y == 3'b000);
    wire s1 = (y == 3'b001);
    wire s2 = (y == 3'b010);
    wire s3 = (y == 3'b011);
    wire s4 = (y == 3'b100);

    // Next state bit 2 (ns2)
    // ns2=1 when (y=001 & x=1) or (y=100 & x=1)
    wire ns2 = (s1 & x) | (s4 & x);

    // Next state bit 1 (ns1)
    // ns1=1 when (y=010 & x=0) or (y=011 & x=1) or (y=100 & x=0)
    wire ns1 = (s2 & ~x) | (s3 & x) | (s4 & ~x);

    // Next state bit 0 (ns0)
    // ns0=1 when (y=000 or y=010) & x=1, else ns0=~x
    wire ns0 = ((s0 | s2) & x) | (~(s0 | s2) & ~x);

    // Output z=1 for y=011 or y=100
    wire z_int = s3 | s4;

    assign Y0 = ns0;
    assign z = z_int;

endmodule