module fixed_point_subtractor #(
    parameter integer N = 16, // total bits
    parameter integer Q = 8   // fractional bits
)(
    input  wire signed [N-1:0] a,
    input  wire signed [N-1:0] b,
    output reg  signed [N-1:0] c
);

    always @(*) begin
        // Perform subtraction directly
        c = a - b;

        // If result is zero, explicitly clear sign bit
        if (c == 0)
            c = {1'b0, {(N-1){1'b0}}};
    end

endmodule