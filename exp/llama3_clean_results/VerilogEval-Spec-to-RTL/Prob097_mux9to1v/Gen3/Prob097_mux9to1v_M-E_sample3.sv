module TopModule(
    input  [15:0] a,
    input  [15:0] b,
    input  [15:0] c,
    input  [15:0] d,
    input  [15:0] e,
    input  [15:0] f,
    input  [15:0] g,
    input  [15:0] h,
    input  [15:0] i,
    input  [3:0] sel,
    output reg [15:0] out
);

reg [15:0] masked_a, masked_b, masked_c, masked_d, masked_e, masked_f, masked_g, masked_h, masked_i;

always @(*) begin
    // Create a mask based on the select signal
    case (sel)
        0: masked_a = a; masked_b = 16'd0; masked_c = 16'd0; masked_d = 16'd0; masked_e = 16'd0; masked_f = 16'd0; masked_g = 16'd0; masked_h = 16'd0; masked_i = 16'd0;
        1: masked_a = 16'd0; masked_b = b; masked_c = 16'd0; masked_d = 16'd0; masked_e = 16'd0; masked_f = 16'd0; masked_g = 16'd0; masked_h = 16'd0; masked_i = 16'd0;
        2: masked_a = 16'd0; masked_b = 16'd0; masked_c = c; masked_d = 16'd0; masked_e = 16'd0; masked_f = 16'd0; masked_g = 16'd0; masked_h = 16'd0; masked_i = 16'd0;
        3: masked_a = 16'd0; masked_b = 16'd0; masked_c = 16'd0; masked_d = d; masked_e = 16'd0; masked_f = 16'd0; masked_g = 16'd0; masked_h = 16'd0; masked_i = 16'd0;
        4: masked_a = 16'd0; masked_b = 16'd0; masked_c = 16'd0; masked_d = 16'd0; masked_e = e; masked_f = 16'd0; masked_g = 16'd0; masked_h = 16'd0; masked_i = 16'd0;
        5: masked_a = 16'd0; masked_b = 16'd0; masked_c = 16'd0; masked_d = 16'd0; masked_e = 16'd0; masked_f = f; masked_g = 16'd0; masked_h = 16'd0; masked_i = 16'd0;
        6: masked_a = 16'd0; masked_b = 16'd0; masked_c = 16'd0; masked_d = 16'd0; masked_e = 16'd0; masked_f = 16'd0; masked_g = g; masked_h = 16'd0; masked_i = 16'd0;
        7: masked_a = 16'd0; masked_b = 16'd0; masked_c = 16'd0; masked_d = 16'd0; masked_e = 16'd0; masked_f = 16'd0; masked_g = 16'd0; masked_h = h; masked_i = 16'd0;
        8: masked_a = 16'd0; masked_b = 16'd0; masked_c = 16'd0; masked_d = 16'd0; masked_e = 16'd0; masked_f = 16'd0; masked_g = 16'd0; masked_h = 16'd0; masked_i = i;
        default: masked_a = 16'd0; masked_b = 16'd0; masked_c = 16'd0; masked_d = 16'd0; masked_e = 16'd0; masked_f = 16'd0; masked_g = 16'd0; masked_h = 16'd0; masked_i = 16'd0;
    endcase

    // Combine the masked inputs using bitwise OR operations
    out = masked_a | masked_b | masked_c | masked_d | masked_e | masked_f | masked_g | masked_h | masked_i;

    // If none of the above cases match, set the output to all '1's
    if (out == 16'd0 && sel >= 4'd9) begin
        out = 16'hFFFF;
    end
end

endmodule