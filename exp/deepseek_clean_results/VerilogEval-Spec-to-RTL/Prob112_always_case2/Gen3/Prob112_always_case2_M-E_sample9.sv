module TopModule (
    input [3:0] in,
    output [1:0] pos
);

    wire lower_half_has_one = |in[1:0];
    wire upper_half_has_one = |in[3:2];
    
    wire [1:0] lower_pos = in[0] ? 2'b00 : 2'b01;
    wire [1:0] upper_pos = in[2] ? 2'b10 : 2'b11;
    
    assign pos = (|in) ? (lower_half_has_one ? lower_pos : upper_pos) : 2'b00;

endmodule