module TopModule(
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] s,
    output reg overflow
);
    wire [8:0] sum;
    wire sign_a, sign_b, sign_s;
    wire signs_match, result_sign_diff;
    
    assign sum = a + b;
    assign sign_a = a[7];
    assign sign_b = b[7];
    assign sign_s = sum[7];
    
    assign signs_match = (sign_a == sign_b);
    assign result_sign_diff = (sign_a != sign_s);
    
    always @(*) begin
        s = sum[7:0];
        overflow = signs_match & result_sign_diff;
    end
endmodule