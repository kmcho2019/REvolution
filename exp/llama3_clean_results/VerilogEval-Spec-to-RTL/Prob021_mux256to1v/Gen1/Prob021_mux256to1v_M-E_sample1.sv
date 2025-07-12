module TopModule(
    input [1023:0] in,
    input [7:0] sel,
    output [3:0] out
);

    always @(in or sel) begin
        case (sel)
            256'd0: out = in[3:0];
            256'd1: out = in[7:4];
            256'd2: out = in[11:8];
            //... explicitly list all cases up to 255
            256'd255: out = in[1023:1020];
            default: out = 4'b0; // default case, in case sel value exceeds 255
        endcase
    end

endmodule