module TopModule (
    input [3:0] in,
    output [1:0] pos
);

    wire upper_active = |in[3:2];
    wire [1:0] upper_pos = in[3] ? 2'b11 : 
                         in[2] ? 2'b10 : 
                         2'b00;
    
    wire [1:0] lower_pos = in[1] ? 2'b01 : 
                         in[0] ? 2'b00 : 
                         2'b00;
    
    assign pos = upper_active ? upper_pos : lower_pos;

endmodule