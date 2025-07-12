module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Create a double-width version of the input for circular rotation
    wire [2047:0] extended_in = {in, in};
    
    // Calculate the shift amount (each 4-bit group needs 4 positions)
    wire [10:0] shift_amount = sel * 4;
    
    // Perform the circular shift and select the first 4 bits
    assign out = (extended_in >> shift_amount)[3:0];

endmodule