module barrel_shifter (
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);
    // Pre-compute all possible rotated versions
    wire [7:0] rotated [0:7];
    
    // Generate all 8 possible rotation amounts (0-7)
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : rotation_gen
            assign rotated[i] = {in[(7-i):0], in[7:(8-i)]};
        end
    endgenerate

    // Select the appropriate rotation based on control signal
    assign out = rotated[ctrl];
endmodule