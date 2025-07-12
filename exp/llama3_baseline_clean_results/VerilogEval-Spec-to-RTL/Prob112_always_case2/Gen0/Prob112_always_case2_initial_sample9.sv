module TopModule(
    input  [3:0] in,
    output [1:0] pos
);

    always @(*) begin
        if (in[3] == 1'b1) begin
            pos = 2'b11; // Output 3 if most significant bit is 1
        end else if (in[2] == 1'b1) begin
            pos = 2'b10; // Output 2 if the second bit is 1
        end else if (in[1] == 1'b1) begin
            pos = 2'b01; // Output 1 if the third bit is 1
        end else if (in[0] == 1'b1) begin
            pos = 2'b00; // Output 0 if the least significant bit is 1
        end else begin
            pos = 2'b00; // Output 0 if none of the bits are 1
        end
    end

endmodule