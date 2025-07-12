module TopModule(
    input [7:0] code,
    output reg [3:0] out,
    output reg valid
);

always @(*) begin
    valid = 0;
    out = 0;
    case (code)
        8'h45: valid = 1; out = 4'd0;
        8'h16: valid = 1; out = 4'd1;
        8'h1e: valid = 1; out = 4'd2;
        8'h26: valid = 1; out = 4'd3;
        8'h25: valid = 1; out = 4'd4;
        8'h2e: valid = 1; out = 4'd5;
        8'h36: valid = 1; out = 4'd6;
        8'h3d: valid = 1; out = 4'd7;
        8'h3e: valid = 1; out = 4'd8;
        8'h46: valid = 1; out = 4'd9;
    endcase
end

endmodule