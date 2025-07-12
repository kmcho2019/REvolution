module TopModule(
    input [7:0] in,
    output [2:0] pos
);

    always @(*) begin
        pos = 3'd0;  // default output
        for (int i = 0; i < 8; i++) begin
            if (in[i] == 1'b1) begin
                pos = i;  // output the position of the first high bit
                break;    // stop the loop once the first high bit is found
            end
        end
    end

endmodule