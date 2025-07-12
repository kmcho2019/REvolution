module TopModule(
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] s,
    output reg overflow
);
    wire [8:0] sum_ext;
    wire sign_a, sign_b, sign_s;
    
    assign sum_ext = {1'b0, a} + {1'b0, b};
    assign sign_a = a[7];
    assign sign_b = b[7];
    assign sign_s = sum_ext[7];
    
    always @(*) begin
        s = sum_ext[7:0];
        overflow = (sign_a == sign_b) & (sign_a != sign_s);
    end
endmodule