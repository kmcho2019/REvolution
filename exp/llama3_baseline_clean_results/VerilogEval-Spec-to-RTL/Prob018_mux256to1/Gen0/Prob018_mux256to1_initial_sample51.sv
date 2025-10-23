module TopModule(
    input  [255:0] in,
    input  [7:0] sel,
    output out
);
    always @(in, sel) begin
        case (sel)
            256'd0: out = in[0];
            256'd1: out = in[1];
            256'd2: out = in[2];
            // ... this approach would be cumbersome and not scalable
            // Instead, we can use a more general approach:
            default: out = in[sel];
        endcase
    end
endmodule