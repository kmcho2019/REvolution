module TopModule (
    output reg out
);
    initial begin
        out = 1'b0;
    end
    
    always @(*) begin
        out <= out;  // Maintains constant 0 through feedback
    end
endmodule