module TopModule(
    input  [3:0] in,
    output reg [1:0] pos
);

integer i;
reg found;

always @(*) begin
    pos = 2'b00; // Default to 0 if no '1' bits are found
    found = 1'b0;
    for (i = 3; i >= 0; i = i - 1) begin
        if (~found && in[i] == 1'b1) begin // Check each bit from MSB to LSB
            pos = i + 1; // Position is the index plus one (since indexing starts at 0)
            found = 1'b1; // Set the found flag to prevent further iterations
        end
    end
end

endmodule