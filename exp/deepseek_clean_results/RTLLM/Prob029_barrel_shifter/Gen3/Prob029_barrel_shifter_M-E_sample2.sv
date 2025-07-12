module barrel_shifter (
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);
    // Create all possible shifted versions
    wire [7:0] shifted_0 = in;
    wire [7:0] shifted_1 = {in[0], in[7:1]};
    wire [7:0] shifted_2 = {in[1:0], in[7:2]};
    wire [7:0] shifted_3 = {in[2:0], in[7:3]};
    wire [7:0] shifted_4 = {in[3:0], in[7:4]};
    wire [7:0] shifted_5 = {in[4:0], in[7:5]};
    wire [7:0] shifted_6 = {in[5:0], in[7:6]};
    wire [7:0] shifted_7 = {in[6:0], in[7]};

    // Final selection multiplexer
    assign out = (ctrl == 3'b000) ? shifted_0 :
                (ctrl == 3'b001) ? shifted_1 :
                (ctrl == 3'b010) ? shifted_2 :
                (ctrl == 3'b011) ? shifted_3 :
                (ctrl == 3'b100) ? shifted_4 :
                (ctrl == 3'b101) ? shifted_5 :
                (ctrl == 3'b110) ? shifted_6 :
                shifted_7;
endmodule