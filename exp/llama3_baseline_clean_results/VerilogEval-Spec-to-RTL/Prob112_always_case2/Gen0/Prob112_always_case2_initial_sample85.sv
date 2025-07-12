module TopModule(
    input  [3:0] in,
    output [1:0] pos
);

always @(in) begin
    if (in[3] == 1'b1) begin
        pos = 2'b11; // position of in[3] is 3
    end else if (in[2] == 1'b1) begin
        pos = 2'b10; // position of in[2] is 2
    end else if (in[1] == 1'b1) begin
        pos = 2'b01; // position of in[1] is 1
    end else if (in[0] == 1'b1) begin
        pos = 2'b00; // position of in[0] is 0
    end else begin
        pos = 2'b00; // if all bits are '0', output '0'
    end
end

endmodule