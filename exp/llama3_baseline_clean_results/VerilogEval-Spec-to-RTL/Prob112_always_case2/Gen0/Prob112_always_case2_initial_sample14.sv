module TopModule(
    input [3:0] in,
    output [1:0] pos
);

    always @(*) begin
        if (in[3]) begin
            pos = 2'b11; // 3 in binary is 11
        end else if (in[2]) begin
            pos = 2'b10; // 2 in binary is 10
        end else if (in[1]) begin
            pos = 2'b01; // 1 in binary is 01
        end else if (in[0]) begin
            pos = 2'b00; // 0 in binary is 00
        end else begin
            pos = 2'b00; // default value when no bit is high
        end
    end

endmodule