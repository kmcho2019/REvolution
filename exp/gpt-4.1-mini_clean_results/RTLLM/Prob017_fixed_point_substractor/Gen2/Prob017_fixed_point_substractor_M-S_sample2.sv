module fixed_point_subtractor #(parameter Q = 8, parameter N = 16) (
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    // Use signed types to represent fixed-point numbers naturally
    wire signed [N-1:0] a_signed = $signed(a);
    wire signed [N-1:0] b_signed = $signed(b);
    reg  signed [N-1:0] res_signed;

    always @(*) begin
        // Perform signed subtraction directly
        res_signed = a_signed - b_signed;

        // If result is zero, explicitly clear sign bit to 0
        if (res_signed == 0)
            c = {1'b0, {N-1{1'b0}}};
        else
            c = res_signed;
    end

endmodule