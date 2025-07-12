module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);

    // Calculate total shift amount as sum of shifts indicated by ctrl bits
    // ctrl[2] represents shift by 4, ctrl[1] by 2, ctrl[0] by 1
    wire [2:0] shift_amount = (ctrl[2] ? 3'd4 : 3'd0) + 
                              (ctrl[1] ? 3'd2 : 3'd0) + 
                              (ctrl[0] ? 3'd1 : 3'd0);

    // Perform rotation by concatenating input twice and indexing
    // This creates a 16-bit bus: in concatenated with itself
    // Then select 8 bits starting from shift_amount
    wire [15:0] doubled_in = {in, in};
    assign out = doubled_in >> shift_amount;

endmodule