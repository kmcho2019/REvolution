module TopModule(
    input  [3:0] x,
    output       f
);

    // Assign bit positions for clarity
    // Given Karnaugh map axes: x[2] x[3] for rows and x[0] x[1] for columns
    // We'll define the index as {x[3], x[2], x[1], x[0]} to map to a 16-entry LUT
    wire [3:0] addr = {x[3], x[2], x[1], x[0]};

    reg f_reg;

    always @(*) begin
        case (addr)
            4'b0000: f_reg = 1'b1;  // x[3]=0, x[2]=0, x[1]=0, x[0]=0  -> f=1
            4'b0001: f_reg = 1'b0;  // 0 0 0 1 -> 0
            4'b0010: f_reg = 1'b1;  // 0 0 1 0 -> 1 (from K-map: row 00 col 10)
            4'b0011: f_reg = 1'b0;  // 0 0 1 1 -> 0
            4'b0100: f_reg = 1'b0;  // 0 1 0 0 -> 0
            4'b0101: f_reg = 1'b0;  // 0 1 0 1 -> 0
            4'b0110: f_reg = 1'b0;  // 0 1 1 0 -> 0
            4'b0111: f_reg = 1'b0;  // 0 1 1 1 -> 0
            4'b1000: f_reg = 1'b1;  // 1 0 0 0 -> 1
            4'b1001: f_reg = 1'b1;  // 1 0 0 1 -> 1
            4'b1010: f_reg = 1'b0;  // 1 0 1 0 -> 0
            4'b1011: f_reg = 1'b1;  // 1 0 1 1 -> 1 (row 10 col 11)
            4'b1100: f_reg = 1'b1;  // 1 1 0 0 -> 1
            4'b1101: f_reg = 1'b1;  // 1 1 0 1 -> 1
            4'b1110: f_reg = 1'b1;  // 1 1 1 0 -> 1
            4'b1111: f_reg = 1'b0;  // 1 1 1 1 -> 0
            default: f_reg = 1'b0;
        endcase
    end

    assign f = f_reg;

endmodule