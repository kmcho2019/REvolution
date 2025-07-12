module fixed_point_adder #(parameter Q = 4, N = 16) (
    input  [N-1:0] a,
    input  [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

always @(*) begin
    if (a[N-1] == b[N-1]) begin
        // Addition
        res = a + b;
    end else begin
        // Subtraction
        if (a > b) begin
            res = a - b;
        end else begin
            res = b - a;
        end
    end
    
    // Overflow handling
    if (res[N-1] == 1'b1 && res[N-2:0] == {N-1{1'b1}}) begin
        c = {N{1'b1}};
    end else if (res[N-1] == 1'b0 && res[N-2:0] == {N-1{1'b0}}) begin
        c = {N{1'b0}};
    end else begin
        c = res;
    end
end

endmodule