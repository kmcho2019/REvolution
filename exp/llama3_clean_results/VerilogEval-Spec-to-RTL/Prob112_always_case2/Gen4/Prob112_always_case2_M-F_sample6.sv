module TopModule(
    input  [3:0] in,
    output reg [1:0] pos // Declare 'pos' as 'reg [1:0]' to fix the syntax error
);

    always @(in) begin
        pos = 2'b00; // Default output when no '1' bits are found
        if (in[3] == 1'b1) pos = 2'b11; // Most significant bit
        else if (in[2] == 1'b1) pos = 2'b10;
        else if (in[1] == 1'b1) pos = 2'b01;
        else if (in[0] == 1'b1) pos = 2'b00; // Least significant bit
    end

endmodule