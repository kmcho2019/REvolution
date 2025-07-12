module TopModule (
    input  [7:0] code,
    output [3:0] out,
    output       valid
);

reg [3:0] out_value;
reg       valid_value;

always @(*) begin
    case (code)
        8'h45: {out_value, valid_value} = {4'd0, 1'b1};
        8'h16: {out_value, valid_value} = {4'd1, 1'b1};
        8'h1e: {out_value, valid_value} = {4'd2, 1'b1};
        8'h26: {out_value, valid_value} = {4'd3, 1'b1};
        8'h25: {out_value, valid_value} = {4'd4, 1'b1};
        8'h2e: {out_value, valid_value} = {4'd5, 1'b1};
        8'h36: {out_value, valid_value} = {4'd6, 1'b1};
        8'h3d: {out_value, valid_value} = {4'd7, 1'b1};
        8'h3e: {out_value, valid_value} = {4'd8, 1'b1};
        8'h46: {out_value, valid_value} = {4'd9, 1'b1};
        default: {out_value, valid_value} = {4'd0, 1'b0};
    endcase
end

assign out = valid_value ? out_value : 4'd0;
assign valid = valid_value;

endmodule