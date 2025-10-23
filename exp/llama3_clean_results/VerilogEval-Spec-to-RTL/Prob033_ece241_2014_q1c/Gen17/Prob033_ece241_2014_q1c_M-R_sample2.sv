// TopModule that integrates the adder and overflow detection
module TopModule(
    input  [7:0] a,  
    input  [7:0] b,  
    output [7:0] s,  
    output      overflow  
);

    reg [8:0] sum;
    reg overflow_reg;

    always @(*) begin
        sum = {1'b0, a} + {1'b0, b};
        s = sum[7:0];
        overflow_reg = (a[7] == b[7] && a[7] != sum[7]);
    end

    assign overflow = overflow_reg;

endmodule