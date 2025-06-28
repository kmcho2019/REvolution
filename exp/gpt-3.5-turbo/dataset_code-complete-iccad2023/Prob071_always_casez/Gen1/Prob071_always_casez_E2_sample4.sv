module TopModule (
  input [7:0] in,
  output reg [2:0] pos
);

always @* begin
    // Initialize the output 'pos' to 0
    pos = 3'd0;
    // Iterate through each bit starting from the LSB
    for (int i=0; i<8; i=i+1) begin
        // Check if the i-th bit is high by performing a bitwise AND operation
        if (in & (1 << i) != 8'h00) begin
            // Assign the position of the first high bit
            pos = i;
            // Exit the loop once the first high bit is found
            break;
        end
    end
end

endmodule