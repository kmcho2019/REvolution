module TopModule(
    input  [7:0] in,  // 8-bit input
    output [2:0] pos   // 3-bit output
);

    reg [2:0] pos_reg;

    always @(*) begin
        pos_reg = 3'd0; // Initialize pos_reg to 0
        for (int i = 0; i < 8; i++) begin
            if (in[i]) begin // Check if the current bit is '1'
                pos_reg = i; // Assign the position to pos_reg
                break; // Exit the loop as soon as the first '1' is found
            end
        end
    end

    assign pos = pos_reg;

endmodule