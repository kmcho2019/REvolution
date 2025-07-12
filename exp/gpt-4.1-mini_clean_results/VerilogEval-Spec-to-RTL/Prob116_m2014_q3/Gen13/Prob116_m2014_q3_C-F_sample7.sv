module TopModule(
    input  [3:0] x, // x[3:0] corresponds to problem bits x[4], x[3], x[2], x[1]
    output reg f
);
    // Map inputs as per problem definition:
    // Problem's x[1], x[2], x[3], x[4] correspond to x[0], x[1], x[2], x[3] in Verilog
    // Karnaugh map rows indexed by x[3]x[4] → bits x[2]x[3]
    // Karnaugh map columns indexed by x[1]x[2] → bits x[0]x[1]
    // Address formed as {row, col} = {x[3], x[2], x[1], x[0]} would be incorrect.
    // Correct address: {x[2], x[3], x[0], x[1]} (row = x[3]x[4] = x[2]x[3], col = x[1]x[2] = x[0]x[1])
    wire [3:0] addr = {x[2], x[3], x[0], x[1]};

    always @(*) begin
        case(addr)
            // x[3]x[4]=00 -> addr[3:2] = 00
            4'b0000: f = 1'b0; // d->0
            4'b0001: f = 1'b0; // 0
            4'b0010: f = 1'b0; // d->0
            4'b0011: f = 1'b0; // d->0

            // x[3]x[4]=01 -> addr[3:2] = 01
            4'b0100: f = 1'b0; // 0
            4'b0101: f = 1'b0; // d->0
            4'b0110: f = 1'b1; // 1
            4'b0111: f = 1'b0; // 0

            // x[3]x[4]=10 -> addr[3:2] = 10
            4'b1000: f = 1'b1; // 1
            4'b1001: f = 1'b1; // 1
            4'b1010: f = 1'b0; // 0
            4'b1011: f = 1'b0; // d->0

            // x[3]x[4]=11 -> addr[3:2] = 11
            4'b1100: f = 1'b1; // 1
            4'b1101: f = 1'b1; // 1
            4'b1110: f = 1'b0; // d->0
            4'b1111: f = 1'b0; // d->0

            default: f = 1'b0; // Safety default
        endcase
    end
endmodule