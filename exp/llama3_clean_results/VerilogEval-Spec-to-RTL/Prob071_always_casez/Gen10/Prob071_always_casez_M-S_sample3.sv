module TopModule(
    input  [7:0] in,
    output reg [2:0] pos
);

    always @(*) begin
        pos = 3'd0; // Initialize pos to 0 by default
        for (int i = 0; i < 8; i++) begin
            if (in[i]) begin
                pos = i; // Update pos with the index of the first '1' found
                break; // Exit the loop once the first '1' is found
            end
        end
    end

endmodule