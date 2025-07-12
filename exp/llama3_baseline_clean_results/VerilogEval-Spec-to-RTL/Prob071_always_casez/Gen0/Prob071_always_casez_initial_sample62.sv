module TopModule(
    input  [7:0] in,
    output [2:0] pos
);

    always @(*) begin
        pos = 3'd0; // Initialize output to 0
        for (int i = 0; i < 8; i++) begin
            if (in[i] == 1'b1) begin // Check each bit from least significant to most
                pos = 3'd(i); // Output the position of the first '1' found
                break; // Exit the loop once the first '1' is found
            end
        end
    end

endmodule