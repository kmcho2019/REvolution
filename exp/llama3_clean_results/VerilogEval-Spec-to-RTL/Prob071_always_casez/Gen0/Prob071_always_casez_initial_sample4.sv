module TopModule(
    input  [7:0] in,  // 8-bit input
    output [2:0] pos   // 3-bit output
);

    always @(in) begin
        pos = 0;  // Initialize output to 0
        for (int i = 0; i < 8; i++) begin
            if (in[i] == 1'b1) begin
                // Convert bit position to 3-bit binary and assign to pos
                pos = i;
                break;  // Exit loop as we've found the first '1'
            end
        end
    end

endmodule