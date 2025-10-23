module TopModule(
    input  [7:0] in,
    output [2:0] pos
);

    always @(in) begin
        pos = 3'd0; // Initialize output to 0, assuming no bits are high
        for (int i = 0; i < 8; i++) begin
            if (in[i] == 1'b1) begin // Check if current bit is '1'
                pos = 3'd(i); // Output the position of the first '1'
                break; // Exit the loop as we've found the first '1'
            end
        end
    end

endmodule