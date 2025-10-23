module TopModule(
    input  [7:0] code,
    output reg [3:0] out,
    output reg       valid
);

    always @(*) begin
        out = 4'h0;
        valid = 1'b0;

        case (code)
            8'h45: out = 4'h0; valid = 1'b1;
            8'h16: out = 4'h1; valid = 1'b1;
            8'h1e: out = 4'h2; valid = 1'b1;
            8'h26: out = 4'h3; valid = 1'b1;
            8'h25: out = 4'h4; valid = 1'b1;
            8'h2e: out = 4'h5; valid = 1'b1;
            8'h36: out = 4'h6; valid = 1'b1;
            8'h3d: out = 4'h7; valid = 1'b1;
            8'h3e: out = 4'h8; valid = 1'b1;
            8'h46: out = 4'h9; valid = 1'b1;
            default: out = 4'h0; valid = 1'b0;
        endcase
    end

endmodule