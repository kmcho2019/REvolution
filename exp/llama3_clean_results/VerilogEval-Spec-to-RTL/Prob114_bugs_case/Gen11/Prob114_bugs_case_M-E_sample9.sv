module TopModule(
    input  [7:0] code,
    output reg [3:0] out,
    output reg       valid
);

    reg [3:0] decode_out;
    reg       decode_valid;

    always @(*) begin
        out = 4'h0;
        valid = 1'b0;
        case (code)
            8'h45: begin decode_out = 4'h0; decode_valid = 1'b1; end
            8'h16: begin decode_out = 4'h1; decode_valid = 1'b1; end
            8'h1e: begin decode_out = 4'h2; decode_valid = 1'b1; end
            8'h26: begin decode_out = 4'h3; decode_valid = 1'b1; end
            8'h25: begin decode_out = 4'h4; decode_valid = 1'b1; end
            8'h2e: begin decode_out = 4'h5; decode_valid = 1'b1; end
            8'h36: begin decode_out = 4'h6; decode_valid = 1'b1; end
            8'h3d: begin decode_out = 4'h7; decode_valid = 1'b1; end
            8'h3e: begin decode_out = 4'h8; decode_valid = 1'b1; end
            8'h46: begin decode_out = 4'h9; decode_valid = 1'b1; end
            default: begin decode_out = 4'h0; decode_valid = 1'b0; end
        endcase
        out = decode_out;
        valid = decode_valid;
    end

endmodule