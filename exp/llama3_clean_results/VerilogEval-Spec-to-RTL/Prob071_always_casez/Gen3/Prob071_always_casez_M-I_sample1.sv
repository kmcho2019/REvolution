module TopModule(
    input [7:0] in,
    output reg [2:0] pos
);

always @(in) begin
    pos = 3'd0; // Initialize pos to 0
    for (int i = 0; i < 8; i++) begin
        if (in[i]) begin
            // Directly assign the position (1-indexed) to pos
            pos = (i + 1) < 8? (i + 1) : 0;
            break; // Exit the loop once the first '1' is found
        end
    end
end

endmodule