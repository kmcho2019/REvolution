// Alternative 1: Behavioral style with always block
module TopModule (
    input  in1,
    input  in2,
    output reg out
);
    always @(*) begin
        out = ~(in1 | in2);
    end
endmodule

// Alternative 2: Structural style with gate instantiation
/*
module TopModule (
    input  in1,
    input  in2,
    output out
);
    // OR gate followed by inverter
    wire or_out;
    or  (or_out, in1, in2);
    not (out, or_out);
endmodule
*/

// Alternative 3: Ternary conditional operator
/*
module TopModule (
    input  in1,
    input  in2,
    output out
);
    assign out = (in1 | in2) ? 1'b0 : 1'b1;
endmodule
*/