module TopModule(
    input [3:0] in,
    output [1:0] pos
);

    always @(*) begin
        if (in[3]) begin
            pos = 2'b11; // Output 3 if most significant bit is 1
        end else if (in[2]) begin
            pos = 2'b10; // Output 2 if second most significant bit is 1
        end else if (in[1]) begin
            pos = 2'b01; // Output 1 if middle bit is 1
        end else if (in[0]) begin
            pos = 2'b00; // Output 0 if least significant bit is 1
        end else begin
            pos = 2'b00; // Output 0 if none of the input bits are 1
        end
    end

endmodule