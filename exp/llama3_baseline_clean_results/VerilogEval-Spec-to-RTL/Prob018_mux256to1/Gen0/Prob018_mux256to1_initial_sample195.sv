module TopModule(
    input [255:0] in,  // 256-bit input vector
    input [7:0] sel,   // 8-bit select signal
    output out          // 1-bit output
);

    always @(in, sel) begin
        case (sel)
            8'd0: out = in[0];
            8'd1: out = in[1];
            8'd2: out = in[2];
            8'd3: out = in[3];
            // ... manually listing all 256 cases is impractical
            // Instead, we can use a for loop to generate the case statements
            // However, a more Verilog-like approach is to use a single line:
            default: out = in[sel];  // This will select the bit based on the value of sel
        endcase
    end

endmodule