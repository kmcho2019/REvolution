// Refactored version 1: Using always block
module TopModule(
    input a,
    input b,
    output reg out
);
    always @(a or b) begin
        out = ~(a | b);
    end
endmodule

// Refactored version 2: Explicit intermediate steps (for demonstration only)
/*
module TopModule(
    input a,
    input b,
    output out
);
    wire or_result;
    assign or_result = a | b;
    assign out = ~or_result;
endmodule
*/