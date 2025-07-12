module TopModule (
    input  [3:0] x,   // x[3] = x4, x[2] = x3, x[1] = x2, x[0] = x1 (problem order)
    output reg      f
);

    // Assign names for clarity
    wire x1 = x[0]; // problem x[1]
    wire x2 = x[1]; // problem x[2]
    wire x3 = x[2]; // problem x[3]
    wire x4 = x[3]; // problem x[4]

    always @(*) begin
        case ({x3,x4}) // row Gray code (x3 x4)
            2'b00: begin // row = 00
                case ({x1,x2}) // column Gray code (x1 x2)
                    2'b00: f = 1'b0; // d -> 0 chosen to simplify
                    2'b01: f = 1'b0;
                    2'b11: f = 1'b0; // d -> 0
                    2'b10: f = 1'b0; // d -> 0
                    default: f = 1'b0;
                endcase
            end
            2'b01: begin // row = 01
                case ({x1,x2})
                    2'b00: f = 1'b0;
                    2'b01: f = 1'b0; // d -> 0
                    2'b11: f = 1'b1;
                    2'b10: f = 1'b0;
                    default: f = 1'b0;
                endcase
            end
            2'b11: begin // row = 11
                case ({x1,x2})
                    2'b00: f = 1'b1;
                    2'b01: f = 1'b1;
                    2'b11: f = 1'b0; // d -> 0 chosen to minimize complexity
                    2'b10: f = 1'b0; // d -> 0
                    default: f = 1'b0;
                endcase
            end
            2'b10: begin // row = 10
                case ({x1,x2})
                    2'b00: f = 1'b1;
                    2'b01: f = 1'b1;
                    2'b11: f = 1'b0;
                    2'b10: f = 1'b0; // d -> 0
                    default: f = 1'b0;
                endcase
            end
            default: f = 1'b0;
        endcase
    end

endmodule