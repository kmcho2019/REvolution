module TopModule (
    input clk,
    input d,
    input r,
    output reg q
);
    always @(posedge clk) 
        q <= r ? 1'b0 : (q != d ? d : q);
endmodule