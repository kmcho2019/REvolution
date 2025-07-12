module TopModule (
    input  [3:0] x,
    output reg    f
);
    // Input bits for clarity
    wire x3 = x[3];
    wire x2 = x[2];
    wire x1 = x[1];
    wire x0 = x[0];

    // Implementing function exactly from K-map using a combinational case statement.
    // Rows = x3x2, Columns = x1x0
    // Karnaugh map values:
    // 00,00 (x3=0,x2=0,x1=0,x0=0): d  -> assign 0
    // 00,01 (0001): 0
    // 00,11 (0011): d -> 0
    // 00,10 (0010): d -> 0
    // 01,00 (0100): 0
    // 01,01 (0101): d -> 0
    // 01,11 (0111): 1
    // 01,10 (0110): 0
    // 11,00 (1100): 1
    // 11,01 (1101): 1
    // 11,11 (1111): d -> 0
    // 11,10 (1110): d -> 0
    // 10,00 (1000): 1
    // 10,01 (1001): 1
    // 10,11 (1011): 0
    // 10,10 (1010): d -> 0

    always @(*) begin
        case (x)
            4'b0000: f = 0; // d => 0
            4'b0001: f = 0;
            4'b0011: f = 0; // d => 0
            4'b0010: f = 0; // d => 0
            4'b0100: f = 0;
            4'b0101: f = 0; // d => 0
            4'b0111: f = 1;
            4'b0110: f = 0;
            4'b1100: f = 1;
            4'b1101: f = 1;
            4'b1111: f = 0; // d => 0
            4'b1110: f = 0; // d => 0
            4'b1000: f = 1;
            4'b1001: f = 1;
            4'b1011: f = 0;
            4'b1010: f = 0; // d => 0
            default: f = 0; // default 0
        endcase
    end

endmodule