module TopModule(
    input  d,
    input  ena,
    output reg q
);

// Maintain the use of a conditional operator for clarity and synthesis efficiency
assign q = (ena) ? d : q;

endmodule