module TopModule(
    input  [3:0] x,
    output reg  f
);
    // Extract row and column indices for clarity
    wire [1:0] row = x[3:2]; // x[3]x[2]
    wire [1:0] col = x[1:0]; // x[1]x[0]

    always @(*) begin
        case (row)
            2'b00: // row 00
                case (col)
                    2'b00: f = 1'b0; // d -> assign 0
                    2'b01: f = 1'b0;
                    2'b10: f = 1'b0; // d -> assign 0
                    2'b11: f = 1'b0; // d -> assign 0
                    default: f = 1'b0;
                endcase
            2'b01: // row 01
                case (col)
                    2'b00: f = 1'b0;
                    2'b01: f = 1'b0; // d -> assign 0
                    2'b10: f = 1'b0;
                    2'b11: f = 1'b1;
                    default: f = 1'b0;
                endcase
            2'b11: // row 11
                case (col)
                    2'b00: f = 1'b1;
                    2'b01: f = 1'b1;
                    2'b10: f = 1'b0; // d -> assign 0
                    2'b11: f = 1'b0; // d -> assign 0
                    default: f = 1'b0;
                endcase
            2'b10: // row 10
                case (col)
                    2'b00: f = 1'b1;
                    2'b01: f = 1'b1;
                    2'b10: f = 1'b0;
                    2'b11: f = 1'b0; // d -> assign 0
                    default: f = 1'b0;
                endcase
            default: f = 1'b0;
        endcase
    end
endmodule