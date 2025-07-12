module TopModule(
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    always @(*) begin
        case (sel)
            256'd0: out = in[3:0];
            256'd1: out = in[7:4];
            256'd2: out = in[11:8];
            // ... (255 more cases for sel = 3 to 255)
            // This is tedious to write. A better approach is:
            default: out = in[sel*4 +: 4]; // Use bit slicing
        endcase
    end

endmodule