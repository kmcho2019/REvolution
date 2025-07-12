module TopModule(
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output [63:0] q
);

reg [63:0] shifter;

always @(posedge clk) begin
    if (load) begin
        shifter <= data;
    end else if (ena) begin
        case (amount)
            2'b00: shifter <= {shifter[62:0], 1'b0}; // shift left by 1 bit
            2'b01: shifter <= {shifter[55:0], 8'b0}; // shift left by 8 bits
            2'b10: shifter <= {shifter[63], shifter[63:1]}; // shift right by 1 bit
            2'b11: shifter <= {8{shifter[63]}, shifter[63:8]}; // shift right by 8 bits
        endcase
    end
end

assign q = shifter;

endmodule