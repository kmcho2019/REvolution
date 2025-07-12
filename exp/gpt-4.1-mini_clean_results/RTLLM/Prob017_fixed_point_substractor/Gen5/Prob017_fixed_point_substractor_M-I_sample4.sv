module fixed_point_subtractor #(
    parameter integer N = 16,  // total bits (including sign)
    parameter integer Q = 8    // fractional bits (unused explicitly but defines format)
)(
    input  wire signed [N-1:0] a,
    input  wire signed [N-1:0] b,
    output reg  signed [N-1:0] c
);

    always @(*) begin
        // Direct signed subtraction preserves fixed-point semantics
        c = a - b;
        // Force sign bit to 0 if result is zero to handle zero sign explicitly
        if (c == 0)
            c = {1'b0, {(N-1){1'b0}}};
    end

endmodule