module TopModule(
    input  [7:0] in,
    output [2:0] pos
);

    always @(*) begin
        pos = 3'd0; // initialize pos to 0
        for (int i = 0; i < 8; i++) begin
            if (in[i] == 1'b1) begin
                pos = 3'd(i); // report the position of the first 1
                break;
            end
        end
    end

endmodule