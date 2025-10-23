module TopModule(
    input  [7:0] code,
    output reg [3:0] out,
    output reg valid
);

    always @(*) begin
        case (code)
            8'h45: {out, valid} = 5'd0;
            8'h16: {out, valid} = 5'd1;
            8'h1e: {out, valid} = 5'd2;
            8'h26: {out, valid} = 5'd3;
            8'h25: {out, valid} = 5'd4;
            8'h2e: {out, valid} = 5'd5;
            8'h36: {out, valid} = 5'd6;
            8'h3d: {out, valid} = 5'd7;
            8'h3e: {out, valid} = 5'd8;
            8'h46: {out, valid} = 5'd9;
            default: {out, valid} = 5'd0;
        endcase
    end

endmodule