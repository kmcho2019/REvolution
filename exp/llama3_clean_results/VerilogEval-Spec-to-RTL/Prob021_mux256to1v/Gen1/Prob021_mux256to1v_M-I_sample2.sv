module TopModule(
    input [1023:0] in,
    input [7:0] sel,
    output [3:0] out
);

    // Use a case statement to decode the select signal and assign the corresponding 4-bit value
    always @(*) begin
        case (sel)
            // For each possible value of sel, assign the corresponding 4-bit value to out
            0:   out = in[3:0];
            1:   out = in[7:4];
            2:   out = in[11:8];
            // Add cases for all possible values of sel up to 255
            // ...
            255: out = in[1023:1020];
            default: out = 4'b0; // Default case to handle any other value of sel
        endcase
    end

endmodule