// Alternative 1: Using logical operators
module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);
    assign f = (x3 & x1) | (~x3 & x2);
endmodule

// Alternative 2: Using case statement (more explicit truth table)
/*
module TopModule (
    input x3,
    input x2,
    input x1,
    output reg f
);
    always @(*) begin
        case ({x3, x2, x1})
            3'b000: f = 1'b0;
            3'b001: f = 1'b0;
            3'b010: f = 1'b1;
            3'b011: f = 1'b1;
            3'b100: f = 1'b0;
            3'b101: f = 1'b1;
            3'b110: f = 1'b0;
            3'b111: f = 1'b1;
        endcase
    end
endmodule
*/