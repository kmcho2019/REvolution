module TopModule (
    input  wire x3,
    input  wire x2,
    input  wire x1,
    output reg  f
);

    // Use a 3-bit vector {x3,x2,x1} to determine f via case
    always @(*) begin
        case ({x3, x2, x1})
            3'b010, // x3=0 x2=1 x1=0 -> f=1
            3'b011, // x3=0 x2=1 x1=1 -> f=1
            3'b101, // x3=1 x2=0 x1=1 -> f=1
            3'b111: // x3=1 x2=1 x1=1 -> f=1
                f = 1'b1;
            default:
                f = 1'b0;
        endcase
    end

endmodule