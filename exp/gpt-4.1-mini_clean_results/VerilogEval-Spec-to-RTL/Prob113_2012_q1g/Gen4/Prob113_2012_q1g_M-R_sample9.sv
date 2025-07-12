module TopModule(
    input  [3:0] x,
    output reg   f
);

wire x3 = x[3];
wire x2 = x[2];
wire x1 = x[1];
wire x0 = x[0];

// Using minterm index = {x3,x2,x1,x0} for case decoding
always @(*) begin
    case (x)
        4'b0000: f = 1; // minterm 0
        4'b0001: f = 1; // minterm 1
        4'b0100: f = 1; // minterm 4
        4'b0101: f = 1; // minterm 5
        4'b0110: f = 1; // minterm 6
        4'b1100: f = 1; // minterm 12
        4'b1110: f = 1; // minterm 14
        4'b1111: f = 1; // minterm 15
        default: f = 0;
    endcase
end

endmodule