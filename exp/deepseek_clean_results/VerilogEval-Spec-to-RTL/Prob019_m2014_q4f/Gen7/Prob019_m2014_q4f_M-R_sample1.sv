module TopModule (
    input in1,
    input in2,
    output reg out
);
    wire in2_not;
    
    assign in2_not = ~in2;
    
    always @(*) begin
        out = in1 & in2_not;
    end
endmodule