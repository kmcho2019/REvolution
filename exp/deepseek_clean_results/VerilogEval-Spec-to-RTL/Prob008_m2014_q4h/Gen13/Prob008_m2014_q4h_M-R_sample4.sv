// Alternative 1: Behavioral style with always block
module TopModule (
    input in,
    output reg out
);
    always @(*) begin
        out = in;
    end
endmodule

// Alternative 2: Structural style with intermediate wire
/*
module TopModule (
    input in,
    output out
);
    wire intermediate;
    assign intermediate = in;
    assign out = intermediate;
endmodule
*/

// Note: The original solution remains the best choice:
// module TopModule (input in, output out);
//     assign out = in;
// endmodule