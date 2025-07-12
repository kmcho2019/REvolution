module TopModule(
    input [7:0] in,
    output reg [2:0] pos
);

always @(in) begin
    pos = 3'd0; // Default output to 0 if no bits are high
    for (int i = 0; i < 8; i++) begin
        if (in[i]) begin
            pos = i; // Assign the position of the first bit that is high
            break; // Exit the loop as soon as the first high bit is found
        end
    end
end

endmodule