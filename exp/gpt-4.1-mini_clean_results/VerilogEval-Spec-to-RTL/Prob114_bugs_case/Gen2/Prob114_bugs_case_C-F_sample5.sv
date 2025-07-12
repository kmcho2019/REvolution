module TopModule(
    input  [7:0] code,
    output reg [3:0] out,
    output valid
);

reg recognized;

always @(*) begin
    // default outputs
    out = 4'd0;
    recognized = 1'b0;

    case (code)
        8'h45: begin out = 4'd0; recognized = 1'b1; end
        8'h16: begin out = 4'd1; recognized = 1'b1; end
        8'h1E: begin out = 4'd2; recognized = 1'b1; end
        8'h26: begin out = 4'd3; recognized = 1'b1; end
        8'h25: begin out = 4'd4; recognized = 1'b1; end
        8'h2E: begin out = 4'd5; recognized = 1'b1; end
        8'h36: begin out = 4'd6; recognized = 1'b1; end
        8'h3D: begin out = 4'd7; recognized = 1'b1; end
        8'h3E: begin out = 4'd8; recognized = 1'b1; end
        8'h46: begin out = 4'd9; recognized = 1'b1; end
        default: begin out = 4'd0; recognized = 1'b0; end
    endcase
end

assign valid = recognized;

endmodule