module TopModule(
    input  [3:0] in,
    output reg [1:0] pos
);

always @(*) begin
    if (in[3] == 1'b1) begin
        pos = 2'b11; // position 4
    end else if (in[2] == 1'b1) begin
        pos = 2'b10; // position 3
    end else if (in[1] == 1'b1) begin
        pos = 2'b01; // position 2
    end else if (in[0] == 1'b1) begin
        pos = 2'b00; // position 1
    end else begin
        pos = 2'b00; // no '1' bits
    end
end

endmodule