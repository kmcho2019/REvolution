module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);
    wire x3_selected_value;
    
    assign x3_selected_value = x3 ? x1 : x2;
    assign f = x3_selected_value;
endmodule