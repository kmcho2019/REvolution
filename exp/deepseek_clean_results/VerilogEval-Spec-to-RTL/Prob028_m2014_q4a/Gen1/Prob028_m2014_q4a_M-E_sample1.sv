module TopModule (
    input d,
    input ena,
    output q
);

wire q_next;
assign q_next = ena ? d : q;
assign q = q_next;

endmodule