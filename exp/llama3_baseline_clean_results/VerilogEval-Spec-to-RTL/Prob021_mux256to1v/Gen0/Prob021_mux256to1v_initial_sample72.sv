module TopModule(
    input [1023:0] in,
    input [7:0] sel,
    output [3:0] out
);

    always @(*) begin
        case (sel)
            default: out = in[3:0];
            for (genvar i = 1; i < 256; i++) begin
                i: out = in[(i*4 + 3) : (i*4)];
            end
        endcase
    end

endmodule