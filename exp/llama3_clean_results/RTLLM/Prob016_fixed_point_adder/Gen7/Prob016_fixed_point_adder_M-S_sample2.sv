module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output reg [N-1:0] c
);

always @(*) begin
    // Perform addition or subtraction based on signs
    reg [N:0] temp_res;
    if (a[N-1] == b[N-1]) begin
        temp_res = (a[N-1] ? -a : a) + (b[N-1] ? -b : b);
    end else begin
        temp_res = (a[N-1] ? -a : a) - (b[N-1] ? -b : b);
    end

    // Handle overflow
    if (temp_res[N]) begin
        c = {N{1'b1}};
    end else begin
        c = temp_res[N-1:0];
    end
end

endmodule