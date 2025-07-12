module TopModule(
    input  [7:0] in,  // 8-bit input
    output [2:0] pos  // 3-bit output
);

    always @(*) begin
        pos = 0;  // Initialize output to zero
        for (int i = 0; i < 8; i++) begin
            if (in[i] == 1'b1) begin  // Check if the current bit is high
                pos = i;  // Assign the position to the output
                break;  // Break the loop as we have found the first high bit
            end
        end
    end

endmodule