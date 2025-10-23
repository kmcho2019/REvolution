module TopModule (
    input [3:0] in,
    output [1:0] pos
);

wire [3:0] mask = in & ((~in) + 1);  // Isolates rightmost 1 bit
wire [1:0] pos_int;

assign pos_int = (mask == 4'b0001) ? 2'b00 :
                 (mask == 4'b0010) ? 2'b01 :
                 (mask == 4'b0100) ? 2'b10 :
                 (mask == 4'b1000) ? 2'b11 : 2'b00;

assign pos = (|in) ? pos_int : 2'b00;  // Handle all-zero case

endmodule