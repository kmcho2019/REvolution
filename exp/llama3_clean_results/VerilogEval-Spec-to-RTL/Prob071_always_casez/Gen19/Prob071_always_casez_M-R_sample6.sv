module TopModule(
    input  [7:0] in,  // 8-bit input
    output [2:0] pos   // 3-bit output
);

    always @(*) begin
        pos = 3'd0;  // Default output
        for (int i = 7; i >= 0; i--) begin
            if (in[i]) begin
                pos = i;  // First set bit found, assign its position
                break;    // Exit the loop
            end
        end
    end

endmodule