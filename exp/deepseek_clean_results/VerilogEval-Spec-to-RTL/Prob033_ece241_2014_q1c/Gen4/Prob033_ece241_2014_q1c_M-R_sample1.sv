module TopModule(
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] s,
    output reg overflow
);
    wire [8:0] sum_ext;
    
    always @(*) begin
        // Perform the addition
        sum_ext = {a[7], a} + {b[7], b};
        s = sum_ext[7:0];
    end
    
    always @(*) begin
        // Overflow detection
        overflow = (a[7] == b[7]) && (s[7] != a[7]);
    end
endmodule