module TopModule(
    input  [3:0] in,
    output reg [1:0] pos
);

always @(*) begin
    if (in[3] == 1'b1) begin // Check MSB first
        pos = 2'b00;
    end else if (in[2] == 1'b1) begin
        pos = 2'b01;
    end else if (in[1] == 1'b1) begin
        pos = 2'b10;
    end else if (in[0] == 1'b1) begin
        pos = 2'b11;
    end else begin // If no '1' bits are found
        pos = 2'b00;
    end
end

endmodule