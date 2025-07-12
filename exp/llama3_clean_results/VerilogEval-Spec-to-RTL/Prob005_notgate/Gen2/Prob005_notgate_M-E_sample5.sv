module TopModule(
    input  in,
    output reg out
);
    
    always @(*) begin
        if (in != out) begin
            out = ~in;
        end else begin
            out = out;
        end
    end
    
endmodule