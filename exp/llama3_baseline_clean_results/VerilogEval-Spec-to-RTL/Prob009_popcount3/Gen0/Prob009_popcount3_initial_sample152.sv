module TopModule(
    input [2:0] in,
    output [1:0] out
);

// population count calculation
wire ones = (in[0] & 1'b1) + (in[1] & 1'b1) + (in[2] & 1'b1);

// encoding the population count using 2 bits
always @(*)
begin
    case (ones)
        0: out = 2'b00;
        1: out = 2'b01;
        2: out = 2'b10;
        3: out = 2'b11;
        default: out = 2'b00; // this should not occur
    endcase
end

endmodule