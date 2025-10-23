module TopModule (
    output reg one
);
    initial begin
        one = 1'b1;
    end
    
    always @(*) begin
        one = 1'b1;
    end
endmodule