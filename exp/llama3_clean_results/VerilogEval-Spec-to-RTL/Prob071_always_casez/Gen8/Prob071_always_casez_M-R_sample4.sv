module TopModule(
    input  [7:0] in,  // 8-bit input
    output reg [2:0] pos  // 3-bit output
);

    always @(*) begin
        casez(in)
            8'b1??????? : pos = 3'b000;
            8'b01?????? : pos = 3'b001;
            8'b001????? : pos = 3'b010;
            8'b0001???? : pos = 3'b011;
            8'b00001??? : pos = 3'b100;
            8'b000001?? : pos = 3'b101;
            8'b0000001? : pos = 3'b110;
            8'b00000001 : pos = 3'b111;
            default     : pos = 3'b000;
        endcase
    end

endmodule