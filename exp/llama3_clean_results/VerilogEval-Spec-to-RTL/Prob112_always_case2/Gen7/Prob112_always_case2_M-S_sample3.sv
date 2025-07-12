module TopModule(
    input  [3:0] in,
    output reg [1:0] pos
);

    always @(in) begin
        pos = 2'b00; // Default output when no '1' bit is found
        if (in[3]) pos = 2'b11; // Position 3
        else if (in[2]) pos = 2'b10; // Position 2
        else if (in[1]) pos = 2'b01; // Position 1
        else if (in[0]) pos = 2'b00; // Position 0
    end

endmodule