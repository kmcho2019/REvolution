module FullAdder(a, b, cin, sum, cout);
    input a, b, cin;
    output sum, cout;
    
    // Maintaining the efficient logic for sum and carry
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (cin & (a | b));
endmodule

module TopModule(x, y, sum);
    input [3:0] x;
    input [3:0] y;
    output [4:0] sum;
    
    // Using a generate block to instantiate and connect full adders in a loop
    genvar i;
    generate
        for (i = 0; i < 4; i++) begin
            wire cout;
            if (i == 0) begin
                // For the first full adder, cin is 0
                FullAdder fa(x[i], y[i], 1'b0, sum[i], cout);
            end else begin
                // For subsequent full adders, cin comes from the previous carry
                FullAdder fa(x[i], y[i], (i == 1) ? sum[4] : sum[i-1], sum[i], cout);
                if (i == 3) begin
                    // For the last full adder, cout becomes the overflow bit
                    assign sum[4] = cout;
                end
            end
        end
    endgenerate
endmodule