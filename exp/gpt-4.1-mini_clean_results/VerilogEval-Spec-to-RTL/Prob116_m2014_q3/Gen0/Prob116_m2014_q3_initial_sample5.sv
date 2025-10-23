module TopModule (
    input  [3:0] x,
    output reg f
);

    always @(*) begin
        case (x)
            4'd7,  // 0111
            4'd8,  // 1000
            4'd9,  // 1001
            4'd12, // 1100
            4'd13: // 1101
                f = 1'b1;
            default:
                f = 1'b0;
        endcase
    end

endmodule