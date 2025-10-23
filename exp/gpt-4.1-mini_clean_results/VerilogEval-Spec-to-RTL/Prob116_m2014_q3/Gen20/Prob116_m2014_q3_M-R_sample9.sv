module TopModule (
    input  [3:0] x,  // x[3]=x4, x[2]=x3, x[1]=x2, x[0]=x1 per problem
    output reg    f
);

    always @(*) begin
        // Default output for don't-care cells
        f = 1'b0;

        case (x[3:2]) // row Gray code
            2'b00: // row 00
                case (x[1:0]) // column Gray code
                    2'b00: f = 1'b0; // d -> 0
                    2'b01: f = 1'b0;
                    2'b11: f = 1'b0; // d -> 0
                    2'b10: f = 1'b0; // d -> 0
                    default: f = 1'b0;
                endcase
            2'b01: // row 01
                case (x[1:0])
                    2'b00: f = 1'b0;
                    2'b01: f = 1'b0; // d
                    2'b11: f = 1'b1;
                    2'b10: f = 1'b0;
                    default: f = 1'b0;
                endcase
            2'b11: // row 11
                case (x[1:0])
                    2'b00: f = 1'b1;
                    2'b01: f = 1'b1;
                    2'b11: f = 1'b0; // d
                    2'b10: f = 1'b0; // d
                    default: f = 1'b0;
                endcase
            2'b10: // row 10
                case (x[1:0])
                    2'b00: f = 1'b1;
                    2'b01: f = 1'b1;
                    2'b11: f = 1'b0;
                    2'b10: f = 1'b0; // d
                    default: f = 1'b0;
                endcase
            default: f = 1'b0;
        endcase
    end

endmodule