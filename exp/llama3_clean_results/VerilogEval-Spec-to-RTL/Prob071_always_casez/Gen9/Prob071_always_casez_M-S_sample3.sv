module TopModule(
    input  [7:0] in,
    output reg [2:0] pos
);

always @(*) begin
    pos = 3'd0; // Default output value
    for (int i = 0; i < 8; i++) begin
        if (in[i]) begin
            pos = i;
            break; // Stop checking once the first '1' is found
        end
    end
end

endmodule