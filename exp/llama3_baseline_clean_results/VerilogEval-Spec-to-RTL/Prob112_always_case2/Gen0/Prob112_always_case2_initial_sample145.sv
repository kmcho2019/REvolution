module TopModule(
    input  [3:0] in,
    output [1:0] pos
);

always @(*) begin
    if (in[3]) begin
        pos = 2'b11; // 3
    end else if (in[2]) begin
        pos = 2'b10; // 2
    end else if (in[1]) begin
        pos = 2'b01; // 1
    end else if (in[0]) begin
        pos = 2'b00; // 0
    end else begin
        pos = 2'b00; // default to 0 if no bits are high
    end
end

endmodule