module TopModule (
    output reg one
);
    initial begin
        one = 1'b1;
    end
    
    always @(posedge 1'b1) begin
        one <= one;
    end
endmodule