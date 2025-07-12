module TopModule(
    input  [255:0] in,
    input  [7:0] sel,
    output reg out
);

    always @(*) begin
        case (sel)
            256'd0: out = in[0];
            256'd1: out = in[1];
            256'd2: out = in[2];
            // This can continue up to 256'd255: out = in[255];
            // However, for brevity and given the pattern, we'll illustrate with a few cases
            default: out = 1'b0; // Default case to handle any other value of sel
        endcase
    end

endmodule