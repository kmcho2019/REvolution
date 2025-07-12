module TopModule (
    input [7:0] in,  // 8-bit input
    output [2:0] pos  // 3-bit output to represent the position
);

    always @(*) begin
        pos = 0;  // default output to zero if no high bit is found
        for (int i = 0; i < 8; i++) begin
            if (in[i] == 1'b1) begin
                pos = i;  // output the position of the first high bit
                break;    // exit the loop once the first high bit is found
            end
        end
    end

endmodule