module TopModule(
    input  in1,
    input  in2,
    output out
);

// Refactored implementation using an always block for combinational logic
always @(*) begin
    out =!(in1 || in2); // Using the '!' operator for negation and '||' for OR
end

endmodule