module TopModule(
    input [255:0] in,
    input [7:0] sel,
    output reg out
);

    always @(*) begin
        case (sel)
            256'd0: out = in[0];
            256'd1: out = in[1];
            256'd2: out = in[2];
            //... (add cases for sel = 3 to 254)
            256'd254: out = in[254];
            256'd255: out = in[255];
            default: out = 1'bx; // handle out-of-range sel values
        endcase
    end

endmodule