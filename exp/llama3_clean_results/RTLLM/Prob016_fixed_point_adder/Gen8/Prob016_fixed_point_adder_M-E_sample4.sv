module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output reg [N-1:0] c
);

// Stage 1: Sign extension and absolute value calculation
reg [N-1:0] a_abs, b_abs;
reg [N-1:0] a_sign, b_sign;
always @(*) begin
    a_abs = (a[N-1] ? ~a + 1 : a);
    b_abs = (b[N-1] ? ~b + 1 : b);
    a_sign = {N{a[N-1]}};
    b_sign = {N{b[N-1]}};
end

// Stage 2: Partial product generation
reg [N-1:0] partial_product1, partial_product2;
always @(*) begin
    partial_product1 = a_abs + b_abs;
    partial_product2 = a_abs - b_abs;
end

// Stage 3: Addition and overflow handling
reg [N:0] temp_res;
always @(*) begin
    if (a_sign == b_sign) begin
        temp_res = partial_product1;
    end else begin
        if (a_abs > b_abs) begin
            temp_res = partial_product2;
        end else begin
            temp_res = ~partial_product2 + 1;
        end
    end
end

// Stage 4: Final result calculation
always @(*) begin
    if (temp_res[N]) begin
        c = {N{1'b1}};
    end else begin
        c = temp_res[N-1:0];
    end
end

endmodule