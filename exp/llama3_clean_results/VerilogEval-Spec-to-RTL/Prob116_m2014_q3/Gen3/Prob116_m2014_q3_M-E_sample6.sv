module TopModule(
    input [3:0] x,
    output f
);

always @(x) begin
    case (x)
        4'b0000: f = 1'b0; // Based on the Karnaugh map for x[3]x[2] = 00, and considering x[1]x[0] as don't care
        4'b0001: f = 1'b0;
        4'b0010: f = 1'b0;
        4'b0011: f = 1'b0;
        4'b0100: f = 1'b0;
        4'b0101: f = 1'b1; // Correcting based on the understanding that x[3] = 0, x[2] = 1, x[1] = 0, x[0] = 1 gives f = 1
        4'b0110: f = 1'b0;
        4'b0111: f = 1'b1;
        4'b1000: f = 1'b1;
        4'b1001: f = 1'b1;
        4'b1010: f = 1'b0;
        4'b1011: f = 1'b0;
        4'b1100: f = 1'b1;
        4'b1101: f = 1'b1;
        4'b1110: f = 1'b1;
        4'b1111: f = 1'b1;
        default: f = 1'b0; // Handling any other case
    endcase
end

endmodule