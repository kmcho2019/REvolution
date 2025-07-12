module fixed_point_adder #(parameter Q = 8, parameter N = 16)
    (input signed [N-1:0] a,
     input signed [N-1:0] b,
     output [N-1:0] c);

    reg signed [N-1:0] res;

    always @(*) begin
        if (a[N-1] == b[N-1]) begin // Same sign, add absolute values
            res = a + b;
        end else begin // Different signs, subtract
            if (a > b) begin
                res = a - b;
            end else begin
                res = b - a;
            end
        end
    end

    assign c = res;

endmodule