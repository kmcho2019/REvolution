// Alternative 1: Explicit wire declaration
module TopModule (
    input in,
    output out
);
    wire internal;
    assign internal = in;
    assign out = internal;
endmodule

// Alternative 2: Procedural assignment
/*
module TopModule (
    input in,
    output out
);
    reg out_reg;
    always @(*) begin
        out_reg = in;
    end
    assign out = out_reg;
endmodule
*/