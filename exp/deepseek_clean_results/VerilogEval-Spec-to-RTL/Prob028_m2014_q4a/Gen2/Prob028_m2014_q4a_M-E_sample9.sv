module TopModule (
    input d,
    input ena,
    output q
);

wire d_and_ena;
wire q_bar;
wire feedback;

// AND gate for the input path
assign d_and_ena = d & ena;

// Feedback path when ena is low
assign feedback = ~ena & q;

// OR gate combines the input path and feedback
assign q = d_and_ena | feedback;

endmodule