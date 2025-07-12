module TopModule(
    input  [7:0] in,
    output [2:0] pos
);

reg [2:0] pos;

always @(in) begin
    integer i;
    pos = 3'd0; // Default value if no '1' bits are found
    for (i = 0; i < 8; i = i + 1) begin
        if (in[i] == 1'b1) begin
            pos = i; // Assign the position of the first '1' bit
            break; // Exit the loop
        end
    end
end

endmodule