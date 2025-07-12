module TopModule (
    output out
);
    reg state;
    initial state = 1'b0;
    
    always @(*) begin
        state <= ~state;
    end
    
    assign out = state & ~state;
endmodule