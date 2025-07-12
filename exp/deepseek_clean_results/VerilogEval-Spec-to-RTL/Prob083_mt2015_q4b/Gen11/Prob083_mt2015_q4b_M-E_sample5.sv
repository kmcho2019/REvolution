module TopModule (
    input x,
    input y,
    output reg z
);

    reg [1:0] prev_input;

    always @(*) begin
        case ({prev_input, x, y})
            4'b0000: z = 1;  // 00 -> 00
            4'b0001: z = 0;  // 00 -> 01
            4'b0010: z = 0;  // 00 -> 10
            4'b0011: z = 1;  // 00 -> 11
            4'b0100: z = 1;  // 01 -> 00
            4'b0101: z = 0;  // 01 -> 01
            4'b0110: z = 0;  // 01 -> 10
            4'b0111: z = 1;  // 01 -> 11
            4'b1000: z = 1;  // 10 -> 00
            4'b1001: z = 0;  // 10 -> 01
            4'b1010: z = 0;  // 10 -> 10
            4'b1011: z = 1;  // 10 -> 11
            4'b1100: z = 1;  // 11 -> 00
            4'b1101: z = 0;  // 11 -> 01
            4'b1110: z = 0;  // 11 -> 10
            4'b1111: z = 1;  // 11 -> 11
        endcase
    end

    always @(posedge x or posedge y) begin
        prev_input <= {x, y};
    end

endmodule