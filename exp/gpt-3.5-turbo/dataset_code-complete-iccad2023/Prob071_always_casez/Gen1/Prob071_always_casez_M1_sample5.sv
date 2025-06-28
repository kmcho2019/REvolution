module TopModule (
  input [7:0] in,
  output reg [2:0] pos
);

always @* begin
    pos = 3'b0; // Initialize position to 0
    bit found = 1'b0; // Flag to indicate if a high bit is found

    for(int i=0; i<8; i=i+1) begin
        if (in[i] == 1'b1 && !found) begin
            pos = i; // Assign the position of the first high bit
            found = 1'b1; // Set the flag to exit the loop
        end
    end
end

endmodule