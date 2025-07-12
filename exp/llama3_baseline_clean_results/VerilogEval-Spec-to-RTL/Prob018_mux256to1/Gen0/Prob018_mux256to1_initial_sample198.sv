module TopModule(
    input [255:0] in,  // 256-bit input vector
    input [7:0] sel,   // 8-bit select signal
    output out         // 1-bit output
);

    always @(*) begin
        case (sel)
            256'd0: out = in[0];
            256'd1: out = in[1];
            256'd2: out = in[2];
            //... (this approach is not efficient for large inputs)
            // Instead, use a more concise and efficient approach:
            default: out = in[sel];
        endcase
    end

    // Alternatively, a more concise and efficient implementation:
    // assign out = in[sel];

endmodule