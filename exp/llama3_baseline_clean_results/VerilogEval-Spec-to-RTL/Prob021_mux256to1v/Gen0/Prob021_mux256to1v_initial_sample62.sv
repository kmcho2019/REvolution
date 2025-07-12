module TopModule(
    input [1023:0] in,
    input [7:0] sel,
    output [3:0] out
);

    always @(*) begin
        case (sel)
            256'd0: out = in[3:0];
            256'd1: out = in[7:4];
            256'd2: out = in[11:8];
            // this would be a lot of typing, use a loop in a generate block instead
        endcase
    end

    // however, to avoid writing out 256 cases, a better approach is
    always @(*) begin
        out = in[{sel, 2'b00} +: 4];
    end

endmodule