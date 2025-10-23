module TopModule(
    input [7:0] code,
    output reg [3:0] out,
    output reg valid
);

reg [3:0] out_val;
reg valid_val;

always @(*) begin
    case (code)
        8'h45: begin out_val = 4'd0; valid_val = 1'b1; end
        8'h16: begin out_val = 4'd1; valid_val = 1'b1; end
        8'h1e: begin out_val = 4'd2; valid_val = 1'b1; end
        8'h26: begin out_val = 4'd3; valid_val = 1'b1; end
        8'h25: begin out_val = 4'd4; valid_val = 1'b1; end
        8'h2e: begin out_val = 4'd5; valid_val = 1'b1; end
        8'h36: begin out_val = 4'd6; valid_val = 1'b1; end
        8'h3d: begin out_val = 4'd7; valid_val = 1'b1; end
        8'h3e: begin out_val = 4'd8; valid_val = 1'b1; end
        8'h46: begin out_val = 4'd9; valid_val = 1'b1; end
        default: begin out_val = 4'd0; valid_val = 1'b0; end
    endcase
    out = out_val;
    valid = valid_val;
end

endmodule