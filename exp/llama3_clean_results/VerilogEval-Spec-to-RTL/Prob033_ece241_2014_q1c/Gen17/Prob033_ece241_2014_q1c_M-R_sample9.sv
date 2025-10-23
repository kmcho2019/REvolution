module TopModule(
    input  [7:0] a,  
    input  [7:0] b,  
    output [7:0] s,  
    output      overflow  
);

    reg [8:0] sum;

    always @(*) begin
        sum = {1'b0, a} + {1'b0, b};
        s = sum[7:0];
        overflow = (a[7] == b[7] && a[7] != s[7]);
    end

endmodule