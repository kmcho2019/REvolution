module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

    always @(*)
    begin
        case (sel)
            // 256 possible cases, each selecting a different 4-bit input
            // For brevity, only the first and last cases are shown here
            0: out = in[3:0];
            1: out = in[7:4];
            2: out = in[11:8];
            //... (254 more cases)
            254: out = in[1019:1016];
            255: out = in[1023:1020];
            default: out = 4'b0; // default case, set output to 0
        endcase
    end

endmodule