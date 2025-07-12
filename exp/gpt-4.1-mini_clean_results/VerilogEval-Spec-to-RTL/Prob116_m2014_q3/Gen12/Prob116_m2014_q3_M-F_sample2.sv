module TopModule(
    input  [3:0] x, // x[3]=x4, x[2]=x3, x[1]=x2, x[0]=x1
    output       f
);

    reg f_reg;
    wire [1:0] row = x[3:2]; // row = x4 x3
    wire [1:0] col = x[1:0]; // col = x2 x1

    always @(*) begin
        case ({row, col})
            6'b00_00: f_reg = 1'b0; // d, assign 0
            6'b00_01: f_reg = 1'b0; // 0
            6'b00_10: f_reg = 1'b0; // d, assign 0
            6'b00_11: f_reg = 1'b0; // d, assign 0

            6'b01_00: f_reg = 1'b0; // 0
            6'b01_01: f_reg = 1'b0; // d, assign 0
            6'b01_10: f_reg = 1'b0; // 0
            6'b01_11: f_reg = 1'b1; // 1

            6'b11_00: f_reg = 1'b1; // 1
            6'b11_01: f_reg = 1'b1; // 1
            6'b11_10: f_reg = 1'b0; // d, assign 0
            6'b11_11: f_reg = 1'b0; // d, assign 0

            6'b10_00: f_reg = 1'b1; // 1
            6'b10_01: f_reg = 1'b1; // 1
            6'b10_10: f_reg = 1'b0; // 0
            6'b10_11: f_reg = 1'b0; // d, assign 0

            default:  f_reg = 1'b0; // fallback, shouldn't occur
        endcase
    end

    assign f = f_reg;

endmodule