module TopModule(
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output out_assign,
    output reg out_always
);

// Using continuous assignment with conditional operator
assign out_assign = (~sel_b1 || ~sel_b2)? a : b;

// Using procedural if statement in an always block with conditional operator
always @(*) begin
    out_always = (~sel_b1 || ~sel_b2)? a : b;
end

endmodule