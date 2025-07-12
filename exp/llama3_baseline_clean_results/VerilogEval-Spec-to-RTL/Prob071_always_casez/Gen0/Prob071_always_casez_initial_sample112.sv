module TopModule(
    input [7:0] in,
    output [2:0] pos
);

    always @(in) begin
        pos = 3'd0; // Initialize output to 0
        for (int i = 0; i < 8; i++) begin
            if (in[i]) begin
                pos = i; // Assign the position of the first 1 to the output
                break; // Break the loop once the first 1 is found
            end
        end
    end

endmodule