module TopModule (
    input in,
    output out
);
    reg out_reg;
    
    always @(in) begin
        out_reg <= in;
    end
    
    assign out = out_reg;
endmodule