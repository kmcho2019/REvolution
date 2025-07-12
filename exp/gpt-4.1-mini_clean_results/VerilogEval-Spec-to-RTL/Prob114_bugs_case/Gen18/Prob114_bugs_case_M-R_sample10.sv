module TopModule(
    input  [7:0] code,
    output [3:0] out,
    output       valid
);

reg [3:0] decoded_digit;
reg       decoded_valid;

always @* begin
    case (code)
        8'h45: begin decoded_digit = 4'd0; decoded_valid = 1'b1; end
        8'h16: begin decoded_digit = 4'd1; decoded_valid = 1'b1; end
        8'h1E: begin decoded_digit = 4'd2; decoded_valid = 1'b1; end
        8'h26: begin decoded_digit = 4'd3; decoded_valid = 1'b1; end
        8'h25: begin decoded_digit = 4'd4; decoded_valid = 1'b1; end
        8'h2E: begin decoded_digit = 4'd5; decoded_valid = 1'b1; end
        8'h36: begin decoded_digit = 4'd6; decoded_valid = 1'b1; end
        8'h3D: begin decoded_digit = 4'd7; decoded_valid = 1'b1; end
        8'h3E: begin decoded_digit = 4'd8; decoded_valid = 1'b1; end
        8'h46: begin decoded_digit = 4'd9; decoded_valid = 1'b1; end
        default: begin decoded_digit = 4'd0; decoded_valid = 1'b0; end
    endcase
end

assign out = decoded_valid ? decoded_digit : 4'd0;
assign valid = decoded_valid;

endmodule