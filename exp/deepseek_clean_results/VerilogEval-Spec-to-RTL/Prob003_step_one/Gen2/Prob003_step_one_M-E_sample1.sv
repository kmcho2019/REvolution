module TopModule (
    output one
);
    reg state;
    
    always @(*) begin
        state = 1'b1;
    end
    
    assign one = state;
endmodule