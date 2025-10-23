module TopModule(
    input [3:0] in,  // 4-bit input vector
    output [1:0] pos  // 2-bit output for position
);

    always @(*) begin
        if (in[3]) begin  // Check most significant bit first
            pos = 2'b11;  // Output position 3
        end else if (in[2]) begin
            pos = 2'b10;  // Output position 2
        end else if (in[1]) begin
            pos = 2'b01;  // Output position 1
        end else if (in[0]) begin
            pos = 2'b00;  // Output position 0
        end else begin
            pos = 2'b00;  // If none of the input bits are high, output 0
        end
    end

endmodule