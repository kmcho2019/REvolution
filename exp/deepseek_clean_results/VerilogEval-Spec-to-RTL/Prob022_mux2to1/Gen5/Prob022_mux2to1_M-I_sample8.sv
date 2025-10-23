// Option 1: Using logical operators (same PPA as ternary)
module TopModule (
    input a,
    input b,
    input sel,
    output out
);
    assign out = (sel & b) | (~sel & a);
endmodule

// Option 2: Using always block (same PPA as ternary)
/*
module TopModule (
    input a,
    input b,
    input sel,
    output out
);
    reg out_reg;
    always @(*) begin
        case (sel)
            1'b0: out_reg = a;
            1'b1: out_reg = b;
        endcase
    end
    assign out = out_reg;
endmodule
*/