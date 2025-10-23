module TopModule(
    input  [3:0] in,  // 4-bit input
    output [1:0] pos  // 2-bit output position
);

    always @(*) begin
        if (in[3]) begin
            pos = 2'b11;  // 3
        end else if (in[2]) begin
            pos = 2'b10;  // 2
        end else if (in[1]) begin
            pos = 2'b01;  // 1
        end else if (in[0]) begin
            pos = 2'b00;  // 0
        end else begin
            pos = 2'b00;  // if none of the bits are high, output 0
        end
    end

endmodule