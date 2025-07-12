module TopModule (
    input  [7:0] code,
    output reg [3:0] out,
    output reg valid
);

always @(*) begin
    valid = 0;
    // Hold previous 'out' value if no valid key is detected to reduce toggling
    // But since this is combinational, we assign out only on valid codes to avoid unnecessary toggling:
    case (code)
        8'h45: begin out = 4'd0; valid = 1; end
        8'h16: begin out = 4'd1; valid = 1; end
        8'h1e: begin out = 4'd2; valid = 1; end
        8'h26: begin out = 4'd3; valid = 1; end
        8'h25: begin out = 4'd4; valid = 1; end
        8'h2e: begin out = 4'd5; valid = 1; end
        8'h36: begin out = 4'd6; valid = 1; end
        8'h3d: begin out = 4'd7; valid = 1; end
        8'h3e: begin out = 4'd8; valid = 1; end
        8'h46: begin out = 4'd9; valid = 1; end
        default: out = out; // maintain previous output value (no change)
    endcase
end

endmodule