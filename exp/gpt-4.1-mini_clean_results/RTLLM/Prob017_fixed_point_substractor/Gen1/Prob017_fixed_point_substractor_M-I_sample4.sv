module fixed_point_subtractor #(parameter N = 16, parameter Q = 8)(
    input  wire signed [N-1:0] a,
    input  wire signed [N-1:0] b,
    output reg  signed [N-1:0] c
);

    always @* begin
        // Perform signed subtraction directly
        signed [N-1:0] temp_res = a - b;

        // If result is zero, force sign bit to zero
        if (temp_res == 0)
            c = {1'b0, {(N-1){1'b0}}};
        else
            c = temp_res;
    end

endmodule