module TopModule (
    input  [2:0] vec,
    output [2:0] outv,
    output       o2,
    output       o1,
    output       o0
);

// Extract individual bits from vec
wire bit0 = vec[0];
wire bit1 = vec[1];
wire bit2 = vec[2];

// Assign outputs from individual bits
assign o0 = bit0;
assign o1 = bit1;
assign o2 = bit2;

// Concatenate bits to form the output vector
assign outv = {bit2, bit1, bit0};

endmodule