// Alternative 1: Using explicit wire declaration
module TopModule (
    output out
);
    wire out = 1'b0;
endmodule

// Alternative 2: Using procedural assignment (less optimal)
/*
module TopModule (
    output reg out
);
    always @(*) begin
        out = 1'b0;
    end
endmodule
*/