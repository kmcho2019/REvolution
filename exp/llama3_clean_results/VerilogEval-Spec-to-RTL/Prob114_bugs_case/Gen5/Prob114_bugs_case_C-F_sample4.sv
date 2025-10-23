module TopModule(
    input [7:0] code,
    output reg [3:0] out,
    output reg valid
);

always @(*) begin
    {out, valid} = {4'd0, 1'b0};
    
    case (code)
        8'h45: {out, valid} = {4'd0, 1'b1};
        8'h16: {out, valid} = {4'd1, 1'b1};
        8'h1e: {out, valid} = {4'd2, 1'b1};
        8'h26: {out, valid} = {4'd3, 1'b1};
        8'h25: {out, valid} = {4'd4, 1'b1};
        8'h2e: {out, valid} = {4'd5, 1'b1};
        8'h36: {out, valid} = {4'd6, 1'b1};
        8'h3d: {out, valid} = {4'd7, 1'b1};
        8'h3e: {out, valid} = {4'd8, 1'b1};
        8'h46: {out, valid} = {4'd9, 1'b1};
    endcase
end

endmodule