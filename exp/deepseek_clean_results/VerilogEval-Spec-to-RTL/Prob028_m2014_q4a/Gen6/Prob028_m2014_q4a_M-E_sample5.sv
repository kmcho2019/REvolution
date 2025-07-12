module TopModule (
    input d,
    input ena,
    output q
);

wire feedback;
assign feedback = q;

assign q = ena ? d : feedback;

endmodule