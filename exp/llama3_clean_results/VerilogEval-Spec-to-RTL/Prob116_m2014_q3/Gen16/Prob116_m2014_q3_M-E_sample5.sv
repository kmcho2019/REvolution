module ConditionX3(
    input x3,
    input x1,
    input x2,
    output wire f_x3
);

assign f_x3 = x3 &&!(x1 && x2) || (x3 && x1 && x2);

endmodule

module ConditionX1X2(
    input x1,
    input x2,
    output wire f_x1x2
);

assign f_x1x2 = x1 && x2;

endmodule

module TopModule(
    input [3:0] x,
    output wire f
);

wire x3, x1, x2;
assign x3 = x[3];
assign x1 = x[1];
assign x2 = x[2];

wire f_x3, f_x1x2;
ConditionX3 condition_x3(x3, x1, x2, f_x3);
ConditionX1X2 condition_x1x2(x1, x2, f_x1x2);

assign f = (x3) || (x1 && x2);

// Alternatively, a more complex version considering the conditional cases
// assign f = (f_x3) || (!x3 && f_x1x2);

endmodule