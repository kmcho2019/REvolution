module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input  [N-1:0] a,
    input  [N-1:0] b,
    output reg [N-1:0] c
);

wire [N-1:0] same_sign_res;
wire [N-1:0] diff_sign_res;

assign same_sign_res = a - b;
assign diff_sign_res = a + (~b + 1'b1);

always @(a or b) begin
    if ((a[N-1] == 1'b0 && b[N-1] == 1'b0) || (a[N-1] == 1'b1 && b[N-1] == 1'b1)) begin
        // Same sign subtraction
        c = same_sign_res;
    end else begin
        // Different sign subtraction
        if (a[N-1] == 1'b0 && b[N-1] == 1'b1) begin
            if (a >= (~b + 1'b1)) begin
                c = diff_sign_res;
            end else begin
                c = ~diff_sign_res + 1'b1;
            end
        end else if (a[N-1] == 1'b1 && b[N-1] == 1'b0) begin
            if (b >= (~a + 1'b1)) begin
                c = diff_sign_res;
                c = ~c + 1'b1;
            end else begin
                c = diff_sign_res;
            end
        end
    end
    
    // Handle zero result
    if (c == 0) begin
        c = {N{1'b0}};
    end
end

endmodule