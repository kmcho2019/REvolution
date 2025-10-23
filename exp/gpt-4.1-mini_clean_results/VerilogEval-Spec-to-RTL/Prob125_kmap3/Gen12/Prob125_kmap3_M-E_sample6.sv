module TopModule(
    input a,
    input b,
    input c,
    input d, // don't care, ignored
    output out
);

// Create a 8-bit ROM for function outputs indexed by {c,b,a}
// We'll fill according to the Karnaugh map ignoring d

// Karnaugh map cells given (cd rows, ab cols):
// d is don't care so we consider only c,b,a for output, ignoring d

// To assign output for each {c,b,a}, for d=0 or 1 we take 'out' value from K-map
// Since d is don't care, we can pick convenient values to form a consistent function

// The order of bits in lookup: bit 0 = {c=0,b=0,a=0}, bit 1 = {0,0,1}, ... bit 7 = {1,1,1}

reg [7:0] lut = 8'b0;

initial begin
    // For each {c,b,a} = 3'b c b a, determine output from K-map with d ignored

    // Let's interpret the map to assign outputs:

    // Mapping based on Karnaugh map (considering d don't care):
    // For each (c,d) row and (a,b) column:

    // We'll choose d=0 to pick output (because d is don't care)

    // c=0,d=0 row:
    // ab=01(0,1) => out=d (don't care) => choose 0
    // ab=00(0,0) => out=0
    // ab=10(1,0) => out=1
    // ab=11(1,1) => out=1

    // c=1,d=0 row:
    // ab=01(0,1) => out=0
    // ab=00(0,0) => out=1
    // ab=10(1,0) => out=1
    // ab=11(1,1) => out=1

    // The inputs a,b,c are bits: a, b, c

    // Let's list out all (c,b,a) and output:

    // c=0,b=0,a=0 => ab=00 c=0 => from c=0,d=0 row, ab=00 out=0
    lut[0] = 0;

    // c=0,b=0,a=1 => ab=10 c=0 => ab=10 out=1
    lut[1] = 1;

    // c=0,b=1,a=0 => ab=01 c=0 => ab=01 out=d (don't care), choose 0
    lut[2] = 0;

    // c=0,b=1,a=1 => ab=11 c=0 => ab=11 out=1
    lut[3] = 1;

    // c=1,b=0,a=0 => ab=00 c=1 => ab=00 out=1
    lut[4] = 1;

    // c=1,b=0,a=1 => ab=10 c=1 => ab=10 out=1
    lut[5] = 1;

    // c=1,b=1,a=0 => ab=01 c=1 => ab=01 out=0
    lut[6] = 0;

    // c=1,b=1,a=1 => ab=11 c=1 => ab=11 out=1
    lut[7] = 1;
end

// use index {c,b,a} to output the correct bit
assign out = lut[{c,b,a}];

endmodule