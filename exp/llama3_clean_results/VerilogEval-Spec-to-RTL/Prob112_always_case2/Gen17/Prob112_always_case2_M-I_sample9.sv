module TopModule(
    input  [3:0] in,
    output reg [1:0] pos
);

always @(*) begin
    pos = 2'b00; // Initialize pos to 0
    for (int i = 3; i >= 0; i--) begin // Iterate from MSB to LSB
        if (in[i]) begin // Check if current bit is '1'
            pos = i; // Output the position of the first '1' bit
            break; // Exit the loop
        end
    end
end

endmodule