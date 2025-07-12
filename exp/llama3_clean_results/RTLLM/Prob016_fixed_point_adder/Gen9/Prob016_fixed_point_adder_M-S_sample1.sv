module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output reg [N-1:0] c
);

reg [N:0] temp_res;

always @(*) begin
    if (a[N-1] == b[N-1]) begin
        // Both positive or both negative, add absolute values
        temp_res = a + b;
    end else begin
        // One positive, one negative, perform subtraction
        if (a > b) begin
            temp_res = a - b;
        end else begin
            temp_res = b - a;
        end
    end
    
    // Overflow handling
    if (temp_res[N]) begin
        c = {N{1'b1}};
    end else begin
        c = temp_res[N-1:0];
    end
end

endmodule