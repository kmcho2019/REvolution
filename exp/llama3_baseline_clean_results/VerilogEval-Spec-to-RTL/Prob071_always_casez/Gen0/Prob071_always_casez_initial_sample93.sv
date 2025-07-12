module TopModule(
    input  [7:0] in,
    output [2:0] pos
);

    always @(*) begin
        pos = 3'd0;  // Initialize pos to 0
        for (int i = 0; i <= 7; i++) begin
            if (in[i] == 1'b1) begin
                pos = i;  // Assign the position of the first '1' to pos
                break;    // Exit the loop
            end
        end
    end

endmodule