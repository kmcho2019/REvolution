module fixed_point_adder #(parameter Q = 8, N = 16)
(
    input   [N-1:0] a,
    input   [N-1:0] b,
    output  [N-1:0] c
);

    reg [N-1:0] res;

    always @(a or b) begin
        if (a[N-1] == b[N-1]) begin // Same sign, add absolute values
            if (a[N-1] == 1'b0) begin // Both positive
                res = a + b;
            end else begin // Both negative
                res = -( -a + (-b) );
            end
        end else begin // Different signs, subtract absolute values
            if (a[N-1] == 1'b0) begin // a is positive, b is negative
                if (a >= -b) begin
                    res = a + b;
                end else begin
                    res = -( -b + (-a) );
                end
            end else begin // a is negative, b is positive
                if (b >= -a) begin
                    res = b + a;
                end else begin
                    res = -( -a + (-b) );
                end
            end
        end
    end

    assign c = res;

endmodule