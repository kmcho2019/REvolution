module TopModule(
    input  [7:0] in,
    output [2:0] pos
);

    always @(*) begin
        pos = 3'd0; // Initialize pos to 0
        for (int i = 0; i < 8; i++) begin
            if (in[i] == 1'b1) begin
                pos = i; // If a bit is high, set pos to its position and break
                break;
            end
        end
    end

endmodule