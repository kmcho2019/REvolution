module TopModule(
    input  [3:0] in,
    output [1:0] pos
);

always @(*) begin
    case(in)
        4'b0000: pos = 2'b00;
        4'b1000: pos = 2'b11; // Position of bit[3]
        4'b0100: pos = 2'b10; // Position of bit[2]
        4'b0010: pos = 2'b01; // Position of bit[1]
        4'b0001: pos = 2'b00; // Position of bit[0]
        default: begin
            // Prioritize the most significant bit
            if(in[3]) pos = 2'b11;
            else if(in[2]) pos = 2'b10;
            else if(in[1]) pos = 2'b01;
            else pos = 2'b00; // This case is technically covered by the previous conditions
        end
    endcase
end

endmodule