// Alternative 1: Explicit wire declaration
module TopModule (
    output out
);
    wire out_wire = 1'b0;
    assign out = out_wire;
endmodule

// Alternative 2: Using always block (less optimal)
/*
module TopModule (
    output reg out
);
    always @(*) begin
        out = 1'b0;
    end
endmodule
*/