module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    // Decode present state y into one-hot signals for valid states using bitwise ANDs
    wire s000 = ~y[2] & ~y[1] & ~y[0];
    wire s001 = ~y[2] & ~y[1] &  y[0];
    wire s010 = ~y[2] &  y[1] & ~y[0];
    wire s011 = ~y[2] &  y[1] &  y[0];
    wire s100 =  y[2] & ~y[1] & ~y[0];

    // Next state bit 2 (ns2) logic:
    // From table: ns2 = x & (s001 | s100)
    wire ns2 = x & (s001 | s100);

    // Next state bit 1 (ns1) logic:
    // ns1 = (~x & (s010 | s100)) | (x & s011)
    wire ns1 = (~x & (s010 | s100)) | (x & s011);

    // Next state bit 0 (ns0) logic as explicit XNOR for better synthesis
    wire cond = s000 | s010;
    wire ns0 = cond ~^ x; // equivalent to (cond & x) | (~cond & ~x)

    // Output z = 1 if present state is s011 or s100
    wire z_int = s011 | s100;

    // Assign outputs
    assign Y0 = ns0;  // Y0 is the LSB of next state Y
    assign z  = z_int;

endmodule