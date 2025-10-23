module TopModule(
    input  [7:0] in,
    output [2:0] pos
);

    always @(*) begin
        pos = 3'd0; // Initialize pos to 0
        for (int i = 0; i < 8; i++) begin
            if (in[i] == 1'b1) begin
                pos = i; // Assign the position of the first '1' bit found
                break; // Exit the loop since we found the first '1'
            end
        end
    end

endmodule