module TopModule(
    input  [3:0] x,
    output reg f
);
    // Map input bits x[3:0] to Karnaugh map bits:
    // Problem's x[1], x[2], x[3], x[4] correspond to x[0], x[1], x[2], x[3] in Verilog
    // Karnaugh map rows indexed by x[3]x[4] -> x[2]x[3] in Verilog bits
    // Karnaugh map columns indexed by x[1]x[2] -> x[0]x[1] in Verilog bits
    // So address to case on is {x[2], x[3], x[0], x[1]}
    wire [3:0] addr = {x[2], x[3], x[0], x[1]};

    always @(*) begin
        case (addr)
            // Rows = x[3]x[4] (bits 2,3), Columns = x[1]x[2] (bits 0,1)
            // Karnaugh map entries with 'd' = 0 for simplicity

            // x[3]x[4]=00 (addr[3:2]=00)
            // x[1]x[2]: 00=0, 01=1, 11=3, 10=2 (columns)
            4'b0000: f = 1'b0; // d -> 0 (row=00, col=00)
            4'b0001: f = 1'b0; // 0 (row=00, col=01)
            4'b0011: f = 1'b0; // d -> 0 (row=00, col=11)
            4'b0010: f = 1'b0; // d -> 0 (row=00, col=10)

            // x[3]x[4]=01 (addr[3:2]=01)
            4'b0100: f = 1'b0; // 0 (row=01, col=00)
            4'b0101: f = 1'b0; // d -> 0 (row=01, col=01)
            4'b0111: f = 1'b1; // 1 (row=01, col=11)
            4'b0110: f = 1'b0; // 0 (row=01, col=10)

            // x[3]x[4]=10 (addr[3:2]=10)
            4'b1000: f = 1'b1; // 1 (row=10, col=00)
            4'b1001: f = 1'b1; // 1 (row=10, col=01)
            4'b1011: f = 1'b0; // 0 (row=10, col=11)
            4'b1010: f = 1'b0; // d -> 0 (row=10, col=10)

            // x[3]x[4]=11 (addr[3:2]=11)
            4'b1100: f = 1'b1; // 1 (row=11, col=00)
            4'b1101: f = 1'b1; // 1 (row=11, col=01)
            4'b1111: f = 1'b0; // d -> 0 (row=11, col=11)
            4'b1110: f = 1'b0; // d -> 0 (row=11, col=10)

            default: f = 1'b0; // Safety fallback
        endcase
    end
endmodule