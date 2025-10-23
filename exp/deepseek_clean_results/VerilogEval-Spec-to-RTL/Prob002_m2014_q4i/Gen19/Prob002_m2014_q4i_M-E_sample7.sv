module TopModule(output out);
    reg state;
    
    initial begin
        state = 0;
    end
    
    always @(*) begin
        state = 0;
    end
    
    assign out = state;
endmodule