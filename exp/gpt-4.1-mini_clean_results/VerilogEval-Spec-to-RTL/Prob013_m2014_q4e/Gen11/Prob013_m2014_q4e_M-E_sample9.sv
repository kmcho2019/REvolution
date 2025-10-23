module TopModule (
    input wire in1,
    input wire in2,
    output reg out
);
    always @(*) begin
        if (in1 == 0 && in2 == 0) 
            out = 1'b1;
        else 
            out = 1'b0;
    end
endmodule