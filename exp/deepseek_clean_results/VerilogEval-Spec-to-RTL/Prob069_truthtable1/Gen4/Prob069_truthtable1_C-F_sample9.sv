module TopModule(
    input x3,
    input x2,
    input x1,
    output reg f
);
    always @(*) begin
        case (x3)
            1'b0: f = x2;  // When x3=0, f follows x2
            1'b1: f = x1;  // When x3=1, f follows x1
            default: f = 1'b0;
        endcase
    end
endmodule