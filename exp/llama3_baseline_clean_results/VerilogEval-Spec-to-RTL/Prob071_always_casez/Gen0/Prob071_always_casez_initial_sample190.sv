module TopModule(
    input  [7:0] in,
    output [2:0] pos
);

    always @(in) begin
        pos = 0; // Initialize output to 0
        for (int i = 0; i < 8; i++) begin
            if (in[i] == 1'b1) begin // Check if current bit is high
                pos = i; // Output the position of the first high bit
                break; // Exit the loop as we've found the first high bit
            end
        end
    end

endmodule