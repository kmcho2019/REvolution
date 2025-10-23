module TopModule(
    input  [7:0] in,  // 8-bit input vector
    output [2:0] pos  // 3-bit output
);

    always @(*) begin
        pos = 3'd0;  // default output as 0
        for (int i = 0; i < 8; i++) begin
            if (in[i] == 1'b1) begin  // check each bit from least significant to most significant
                pos = 3'd(i);  // assign output as the position of the first '1'
                break;  // exit the loop once we find the first '1'
            end
        end
    end

endmodule