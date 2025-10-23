module TopModule (
    input [7:0] in,
    output [2:0] pos
);

// First level: Check each bit pair in parallel
wire [1:0] pos01 = in[0] ? 2'b00 : (in[1] ? 2'b01 : 2'b11);
wire [1:0] pos23 = in[2] ? 2'b10 : (in[3] ? 2'b11 : 2'b11);
wire [1:0] pos45 = in[4] ? 2'b00 : (in[5] ? 2'b01 : 2'b11);
wire [1:0] pos67 = in[6] ? 2'b10 : (in[7] ? 2'b11 : 2'b11);

// Second level: Select between pairs
wire [1:0] lower = (pos01 != 2'b11) ? pos01 : pos23;
wire [1:0] upper = (pos45 != 2'b11) ? pos45 : pos67;

// Final selection: Prioritize lower nibble
assign pos = (lower != 2'b11) ? {1'b0, lower} : 
             (upper != 2'b11) ? {1'b1, upper} : 3'b000;

endmodule