module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input  [N-1:0] a,
    input  [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

always @(a or b) begin
    // Same sign subtraction
    if ((a[N-1] == 1'b0 && b[N-1] == 1'b0) || (a[N-1] == 1'b1 && b[N-1] == 1'b1)) begin
        res = a - b;
    end else begin
        // Different sign subtraction
        if (a[N-1] == 1'b0 && b[N-1] == 1'b1) begin
            if (a >= ~b + 1'b1) begin
                res = a + ~b + 1'b1;
            end else begin
                res = (~a + 1'b1) + b;
                res = ~res + 1'b1;
            end
        end else if (a[N-1] == 1'b1 && b[N-1] == 1'b0) begin
            if (b >= ~a + 1'b1) begin
                res = b + ~a + 1'b1;
                res = ~res + 1'b1;
            end else begin
                res = (~b + 1'b1) + a;
            end
        end
    end
    
    // Handle zero result
    if (res == 0) begin
        c = {N{1'b0}};
    end else begin
        c = res;
    end
end

endmodule