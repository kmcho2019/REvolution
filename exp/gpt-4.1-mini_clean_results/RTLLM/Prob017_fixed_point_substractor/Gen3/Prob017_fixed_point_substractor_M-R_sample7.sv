module fixed_point_subtractor #(
    parameter integer N = 16, // total bits
    parameter integer Q = 8   // fractional bits (not used explicitly in arithmetic)
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    // Internal signed signals for inputs and result
    wire signed [N-1:0] a_signed = a;
    wire signed [N-1:0] b_signed = b;
    wire signed [N-1:0] res_signed;

    // Perform the subtraction
    assign res_signed = a_signed - b_signed;

    // Internal register to hold the final result
    reg signed [N-1:0] res_reg;

    always @(*) begin
        if (res_signed == 0) begin
            // If result is zero, force sign bit to 0 explicitly
            res_reg = {1'b0, {(N-1){1'b0}}};
        end else begin
            res_reg = res_signed;
        end
    end

    // Drive output
    always @(*) begin
        c = res_reg;
    end

endmodule