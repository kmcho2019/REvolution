// Define the TopModule that splits the input into high and low bytes
module TopModule(
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);

    // Directly extract the high byte (bits 15:8) and assign it to out_hi
    assign out_hi = in[15:8];
    
    // Directly extract the low byte (bits 7:0) and assign it to out_lo
    assign out_lo = in[7:0];

endmodule