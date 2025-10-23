module TopModule(
    input [255:0] in,
    input [7:0] sel,
    output out
);

    always @(in, sel) begin
        case (sel)
            256'd0: out = in[0];
            256'd1: out = in[1];
            256'd2: out = in[2];
            // ... manually writing all 256 cases is impractical
            // instead, we can use a more general approach
            default: out = in[sel];
        endcase
    // using a case statement with a default can be simplified
    // by directly assigning the selected bit
    // out = in[sel];
    end

    // A more concise and practical implementation would be:
    // assign out = in[sel];

endmodule