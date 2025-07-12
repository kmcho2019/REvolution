module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Combine inputs for indexing
    wire [1:0] ab = {a, b};
    wire [1:0] cd = {c, d};

    // Each entry corresponds to one row of the K-map (cd)
    // Stored as 4 bits for ab=00,01,11,10 in that order
    // From the problem:
    // cd=00: ab=00->1,01->1,11->0,10->1  => 4'b1101 (index ab = 00 to 11)
    // cd=01: ab=00->1,01->0,11->0,10->1  => 4'b1001
    // cd=11: ab=00->0,01->1,11->1,10->1  => 4'b0111
    // cd=10: ab=00->1,01->1,11->0,10->0  => 4'b1100
    //
    // Note: K-map ordering of ab columns is 00,01,11,10 => indices 0,1,2,3 respectively.
    // So indexing for ab=00(0),01(1),11(2),10(3)
    // To select the bit for current ab index, we can index the vector directly.
    // Remember that bits are indexed from LSB (0) to MSB (3), so ab values must map correctly.

    reg [3:0] row_data;
    always @(*) begin
        case (cd)
            2'b00: row_data = 4'b1101; // cd=00
            2'b01: row_data = 4'b1001; // cd=01
            2'b11: row_data = 4'b0111; // cd=11
            2'b10: row_data = 4'b1100; // cd=10
            default: row_data = 4'b0000; // default safe case
        endcase
    end

    // Map ab to index 0-3 according to K-map column order (00,01,11,10)
    // ab: 00->0, 01->1, 11->2, 10->3
    wire [1:0] ab_idx = ab;
    wire [1:0] ab_map;
    assign ab_map = (ab == 2'b11) ? 2'd2 :
                    (ab == 2'b10) ? 2'd3 : ab; 
    // Note: This map is trivial except for 11 and 10 swapped to 2 and 3 respectively, which matches original ab.

    assign out = row_data[ab_map];

endmodule