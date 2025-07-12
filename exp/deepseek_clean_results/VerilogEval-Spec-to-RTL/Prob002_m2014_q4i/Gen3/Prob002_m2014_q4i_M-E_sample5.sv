module TopModule (
    output out
);
    reg state;
    
    initial begin
        state = 1'b0;
    end
    
    always @(*) begin
        state = 1'b0;
    end
    
    assign out = state;
endmodule