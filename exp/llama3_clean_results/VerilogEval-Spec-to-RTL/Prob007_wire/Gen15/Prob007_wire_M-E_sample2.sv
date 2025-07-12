module TopModule(
    input  in,
    output out
);
    
    reg out_reg;
    assign out = out_reg;
    
    always @(posedge 1'b1) begin
        out_reg <= in;
    end

endmodule