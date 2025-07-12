module TopModule(
    input [7:0] in,  // 8-bit input
    output [2:0] pos  // 3-bit output for position
);

    always @(*) begin
        pos = 0;  // default output to 0
        for (int i = 0; i < 8; i++) begin
            if (in[i]) begin  // if the current bit is 1
                pos = i;  // output the position
                break;  // exit the loop since we've found the first 1
            end
        end
    end

endmodule