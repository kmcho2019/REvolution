module TopModule (
    input in1,
    input in2,
    output reg out
);
    reg in2_delayed;
    
    always @(*) begin
        in2_delayed <= in2;
    end
    
    always @(posedge (in2_delayed & ~in2)) begin
        out <= in1;
    end
    
    initial begin
        out = 1'b0;
        in2_delayed = 1'b0;
    end
endmodule