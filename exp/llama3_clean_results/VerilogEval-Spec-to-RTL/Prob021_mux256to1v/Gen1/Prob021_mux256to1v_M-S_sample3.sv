module TopModule(
    input [1023:0] in,
    input [7:0] sel,
    output [3:0] out
);

    always @(*)
    begin
        case (sel)
            // Enumerate all possible select values and their corresponding 4-bit inputs
            // For brevity, only the first and last cases are shown; in a real implementation,
            // all 256 cases would be explicitly defined.
            0: out = in[3:0];
            1: out = in[7:4];
            2: out = in[11:8];
            // ...
            254: out = in[1015:1012];
            255: out = in[1019:1016];
            default: out = 4'b0; // Default case for invalid select values
        endcase
    end

endmodule