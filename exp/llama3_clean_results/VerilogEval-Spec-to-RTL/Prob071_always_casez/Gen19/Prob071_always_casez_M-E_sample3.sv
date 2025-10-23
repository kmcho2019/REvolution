module TopModule(
    input  [7:0] in,  // 8-bit input
    output [2:0] pos   // 3-bit output
);

    reg [2:0] pos_reg;

    always @(*) begin
        pos_reg = 3'd0;  // Initialize output to 0
        for (int i = 7; i >= 0; i--) begin
            if (in[i]) begin
                // Set output to the position of the first '1' found
                pos_reg = 3'd(i);
                break;  // Exit the loop as soon as the first '1' is found
            end
        end
    end

    assign pos = pos_reg;

endmodule