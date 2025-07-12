module TopModule (
    input [3:0] in,
    output [1:0] pos
);

wire upper_half_has_1 = |in[3:2];
wire lower_half_has_1 = |in[1:0];

// Upper half (bits 3-2) processing
wire upper_bit_has_1 = in[3];
wire [1:0] upper_pos = {1'b1, ~upper_bit_has_1}; // 3 or 2

// Lower half (bits 1-0) processing
wire lower_bit_has_1 = in[1];
wire [1:0] lower_pos = {1'b0, ~lower_bit_has_1}; // 1 or 0

// Final selection
assign pos = (|in) ? 
             (upper_half_has_1 ? upper_pos : lower_pos) : 
             2'b00;

endmodule