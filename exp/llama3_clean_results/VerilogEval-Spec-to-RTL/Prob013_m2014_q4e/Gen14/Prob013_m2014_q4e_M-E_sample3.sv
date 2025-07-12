module TopModule(
    input  in1,
    input  in2,
    output out
);
    reg out_reg;
    
    always @(*)
    begin
        case ({in1, in2})
            2'b00: out_reg = 1'b1;
            2'b01, 2'b10, 2'b11: out_reg = 1'b0;
        endcase
    end
    
    assign out = out_reg;
endmodule